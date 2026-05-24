import 'package:uuid/uuid.dart';

enum MessageRole { user, assistant, system }

enum MessageType { text, severityInput, severityResult }

class ChatMessage {
  ChatMessage({
    String? id,
    required this.role,
    required this.content,
    this.type = MessageType.text,
    this.severityValue,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  final String id;
  final MessageRole role;
  final String content;
  final MessageType type;

  final int? severityValue;

  final DateTime createdAt;

  ChatMessage copyWith({
    String? content,
    MessageType? type,
    int? severityValue,
  }) {
    return ChatMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      type: type ?? this.type,
      severityValue: severityValue ?? this.severityValue,
      createdAt: createdAt,
    );
  }

  Map<String, String> toApiMap() {
    final roleStr = switch (role) {
      MessageRole.user => 'user',
      MessageRole.assistant => 'assistant',
      MessageRole.system => 'system',
    };

    String resolvedContent = content;
    if (type == MessageType.severityResult && severityValue != null) {
      resolvedContent = '$content [Symptom severity: $severityValue/10]';
    }

    return {'role': roleStr, 'content': resolvedContent};
  }
}
