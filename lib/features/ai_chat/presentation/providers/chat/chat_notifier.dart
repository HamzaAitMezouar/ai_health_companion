import 'dart:async';
import 'dart:developer';

import 'package:ai_health_companion/core/constants/lists.dart';
import 'package:ai_health_companion/core/constants/strings.dart';
import 'package:ai_health_companion/core/errors/exceptions.dart';
import 'package:ai_health_companion/core/network/connectivity_service.dart';
import 'package:ai_health_companion/features/ai_chat/data/datasource/llm_service/gemma_client.dart';
import 'package:ai_health_companion/features/ai_chat/data/datasource/llm_service/llm_client.dart';
import 'package:ai_health_companion/features/ai_chat/data/datasource/llm_service/openai_client.dart';
import 'package:ai_health_companion/features/ai_chat/data/datasource/local_datasource/local_conversation_repository.dart';
import 'package:ai_health_companion/features/ai_chat/data/models/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_state.dart';

class ChatNotifier extends Notifier<ChatState> {
  late final LlmClient _llm;
  late final ConnectivityService _connectivity;
  late final LocalConversationRepository _repo;
  late final GemmaClient _gemmaClient;
  StreamSubscription<bool>? _connectivitySub;
  String? _pendingMessageText;

  @override
  ChatState build() {
    _llm = ref.watch(llmClientProvider);
    _connectivity = ref.watch(connectivityProvider);
    _repo = ref.watch(conversationRepositoryProvider);
    _gemmaClient = ref.watch(gemmaClientProvider);
    _connectivitySub = _connectivity.onConnectivityChanged.listen((online) {
      state = state.copyWith(isOnline: online, clearError: online);
    });

    ref.onDispose(() => _connectivitySub?.cancel());
    Future.microtask(_loadHistory);
    return const ChatState();
  }

  Future<void> _loadHistory() async {
    try {
      state = state.copyWith(isHistoryLoading: true);
      final history = await _repo.loadHistory();
      if (history.isNotEmpty) {
        state = state.copyWith(messages: history);
      }
    } finally {
      state = state.copyWith(isHistoryLoading: false);
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || !state.canSend) return;
    final isOnline = await _connectivity.isConnected;
    if (!isOnline) {
      await _sendChatMessage(
        ChatMessage(role: MessageRole.user, content: text.trim()),
      );

      return;
    }

    if (_containsSeverityKeyword(text)) {
      _pendingMessageText = text.trim();
      showSeveritySlider();
      return;
    }

    await _sendChatMessage(
      ChatMessage(role: MessageRole.user, content: text.trim()),
    );
  }

  Future<void> confirmSeverity({
    required String baseText,
    required int severity,
  }) async {
    final text = baseText.trim().isNotEmpty
        ? baseText.trim()
        : _pendingMessageText ?? '';

    _pendingMessageText = null;

    final severityMessage = ChatMessage(
      role: MessageRole.user,
      content: text,
      type: MessageType.severityResult,
      severityValue: severity,
    );

    state = state.copyWith(
      messages: state.messages
          .where((m) => m.type != MessageType.severityInput)
          .toList(),
    );

    await _sendChatMessage(severityMessage);
  }

  void showSeveritySlider() {
    if (state.isStreaming) return;

    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(
          role: MessageRole.user,
          content: '',
          type: MessageType.severityInput,
        ),
      ],
    );
  }

  void dismissSeveritySlider() {
    final text = _pendingMessageText;
    _pendingMessageText = null;

    state = state.copyWith(
      messages: state.messages
          .where((m) => m.type != MessageType.severityInput)
          .toList(),
    );

    if (text != null && text.isNotEmpty) {
      _sendChatMessage(ChatMessage(role: MessageRole.user, content: text));
    }
  }

  Future<void> clearConversation() async {
    await _repo.clearHistory();
    state = const ChatState();
  }

  void dismissError() => state = state.copyWith(clearError: true);

  Future<void> _sendChatMessage(ChatMessage userMessage) async {
    final isOnline = await _connectivity.isConnected;
    if (await _gemmaClient.isModelInstalled() == false && !isOnline)
      state = state.copyWith(error: NetworkException());

    await _repo.saveMessage(userMessage);

    state = state.copyWith(
      messages: [
        ...state.messages,
        userMessage,
        ChatMessage(role: MessageRole.assistant, content: ''),
      ],
      isStreaming: true,
      clearError: true,
    );

    try {
      final contextMessages = _buildContext();

      if (!isOnline) {
        log("giiiii");
        await for (final token in _gemmaClient.streamCompletion(
          contextMessages,
        )) {
          final updated = state.messages.last.copyWith(
            content: state.messages.last.content + token,
          );
          state = state.copyWith(
            messages: [...state.messages.dropLast(), updated],
          );
        }
      } else {
        await for (final token in _llm.streamCompletion(contextMessages)) {
          final updated = state.messages.last.copyWith(
            content: state.messages.last.content + token,
          );
          state = state.copyWith(
            messages: [...state.messages.dropLast(), updated],
          );
        }
      }

      await _repo.saveMessage(state.messages.last);
    } on CustomException catch (e) {
      state = state.copyWith(messages: state.messages.dropLast(), error: e);
    } catch (e) {
      state = state.copyWith(
        messages: state.messages.dropLast(),
        error: UnknownException(),
      );
    } finally {
      state = state.copyWith(isStreaming: false);
    }
  }

  List<ChatMessage> _buildContext() {
    return [
      ChatMessage(
        role: MessageRole.system,
        content: Strings.kHealthCompanionSystemPrompt,
      ),
      ...state.messages,
    ];
  }

  bool _containsSeverityKeyword(String text) {
    final lower = text.toLowerCase();
    return Lists.kSeverityDetectors.any((keyword) => lower.contains(keyword));
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);

extension _ListExt<T> on List<T> {
  List<T> dropLast() => length > 0 ? sublist(0, length - 1) : [];
}
