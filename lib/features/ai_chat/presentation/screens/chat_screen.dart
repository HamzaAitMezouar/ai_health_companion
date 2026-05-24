import 'dart:math';

import 'package:ai_health_companion/core/constants/lists.dart';
import 'package:ai_health_companion/core/errors/exceptions.dart';
import 'package:ai_health_companion/core/theme/theme.dart';
import 'package:ai_health_companion/core/xtension/intextension.dart';
import 'package:ai_health_companion/features/ai_chat/presentation/providers/chat/chat_notifier.dart';
import 'package:ai_health_companion/features/ai_chat/presentation/providers/model_install/model_install_notifier.dart';
import 'package:ai_health_companion/features/ai_chat/presentation/providers/model_install/modelinstall_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_health_companion/core/network/connectivity_service.dart';
import 'package:ai_health_companion/features/ai_chat/data/models/chat_message.dart';
import 'package:ai_health_companion/features/ai_chat/presentation/providers/chat/chat_state.dart';

part '../widgets/app_bar.dart';
part '../widgets/offline_banner.dart';
part '../widgets/empty_state.dart';
part '../widgets/chat_input_bar.dart';
part '../widgets/typing_indicator.dart';
part '../widgets/severity_slider_card.dart';
part '../widgets/snackbar_error.dart';
part '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final isOnline = ref.watch(isOnlineProvider).valueOrNull ?? true;

    ref.listen<ChatState>(chatProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        SnackbarError.call(context, next.error);
        ref.read(chatProvider.notifier).dismissError();
      }

      if (next.messages.length != prev?.messages.length || next.isStreaming) {
        _scrollToBottom();
      }
    });

    final displayMessages = chatState.messages
        .where((m) => m.role != MessageRole.system)
        .toList();

    return Scaffold(
      appBar: const CustomAppBar(),
      body: chatState.isHistoryLoading
          ? const Center(child: CupertinoActivityIndicator())
          : Column(
              children: [
                if (!isOnline) const OfflineBanner(),

                Expanded(
                  child: chatState.isEmpty
                      ? const EmptyState()
                      : _buildMessageList(displayMessages, chatState),
                ),

                ChatInputBar(
                  canSend: chatState.canSend,
                  onSend: (text) =>
                      ref.read(chatProvider.notifier).sendMessage(text),
                  onSeverityTap: () {
                    ref.read(chatProvider.notifier).showSeveritySlider();
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages, ChatState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isLastMessage = index == messages.length - 1;
        final isStreamingThis = isLastMessage && state.isStreaming;

        return MessageBubble(
          key: ValueKey(message.id),
          message: message,
          isStreaming: isStreamingThis,
          onSeverityConfirm: (text, severity) => ref
              .read(chatProvider.notifier)
              .confirmSeverity(baseText: text, severity: severity),
          onSeverityDismiss: () {
            ref.read(chatProvider.notifier).dismissSeveritySlider();
          },
        );
      },
    );
  }
}
