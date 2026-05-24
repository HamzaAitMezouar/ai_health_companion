import 'package:ai_health_companion/features/ai_chat/data/datasource/local_datasource/daos/messages_dao.dart';
import 'package:ai_health_companion/features/ai_chat/data/datasource/local_datasource/local_database.dart';
import 'package:ai_health_companion/features/ai_chat/data/models/chat_message.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class LocalConversationRepository {
  Future<List<ChatMessage>> loadHistory();
  Future<void> saveMessage(ChatMessage message);
  Future<void> saveAll(List<ChatMessage> messages);
  Future<void> clearHistory();
  Stream<List<ChatMessage>> watchHistory();
}

class DriftConversationRepository implements LocalConversationRepository {
  DriftConversationRepository(this._dao);

  final MessagesDao _dao;

  @override
  Future<List<ChatMessage>> loadHistory() async {
    final rows = await _dao.getAllMessages();
    return rows.map(_rowToMessage).toList();
  }

  @override
  Future<void> saveMessage(ChatMessage message) =>
      _dao.upsertMessage(_messageToCompanion(message));

  @override
  Future<void> saveAll(List<ChatMessage> messages) =>
      _dao.upsertAll(messages.map(_messageToCompanion).toList());

  @override
  Future<void> clearHistory() => _dao.clearAll();

  @override
  Stream<List<ChatMessage>> watchHistory() =>
      _dao.watchAllMessages().map((rows) => rows.map(_rowToMessage).toList());

  MessagesCompanion _messageToCompanion(ChatMessage m) {
    return MessagesCompanion(
      id: Value(m.id),
      role: Value(_roleToString(m.role)),
      content: Value(m.content),
      type: Value(_typeToString(m.type)),
      severityValue: Value(m.severityValue),
      createdAt: Value(m.createdAt),
    );
  }

  ChatMessage _rowToMessage(Message row) {
    return ChatMessage(
      id: row.id,
      role: _roleFromString(row.role),
      content: row.content,
      type: _typeFromString(row.type),
      severityValue: row.severityValue,
      createdAt: row.createdAt,
    );
  }

  String _roleToString(MessageRole role) => switch (role) {
    MessageRole.user => 'user',
    MessageRole.assistant => 'assistant',
    MessageRole.system => 'system',
  };

  MessageRole _roleFromString(String role) => switch (role) {
    'user' => MessageRole.user,
    'assistant' => MessageRole.assistant,
    'system' => MessageRole.system,
    _ => MessageRole.user,
  };

  String _typeToString(MessageType type) => switch (type) {
    MessageType.text => 'text',
    MessageType.severityInput => 'severity_input',
    MessageType.severityResult => 'severity_result',
  };

  MessageType _typeFromString(String type) => switch (type) {
    'severity_input' => MessageType.severityInput,
    'severity_result' => MessageType.severityResult,
    _ => MessageType.text,
  };
}

final messagesDaoProvider = Provider<MessagesDao>((ref) {
  return MessagesDao(ref.watch(appDatabaseProvider));
});

final conversationRepositoryProvider = Provider<LocalConversationRepository>((
  ref,
) {
  return DriftConversationRepository(ref.watch(messagesDaoProvider));
});
