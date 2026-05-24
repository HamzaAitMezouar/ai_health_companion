import 'package:ai_health_companion/core/errors/exceptions.dart';
import 'package:ai_health_companion/features/ai_chat/data/models/chat_message.dart';

class ChatState {
  const ChatState({
    this.messages = const [],
    this.isStreaming = false,
    this.error,
    this.isOnline = true,
    this.isHistoryLoading = false,
  });

  final List<ChatMessage> messages;

  final bool isStreaming;
  final bool isHistoryLoading;
  final CustomException? error;

  final bool isOnline;

  bool get isEmpty => messages.isEmpty;

  bool get canSend => !isStreaming;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isStreaming,
    CustomException? error,
    bool clearError = false,
    bool? isOnline,
    bool? isHistoryLoading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      error: clearError ? null : (error ?? this.error),
      isOnline: isOnline ?? this.isOnline,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
    );
  }
}
