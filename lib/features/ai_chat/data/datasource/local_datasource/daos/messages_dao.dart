import 'package:ai_health_companion/features/ai_chat/data/datasource/local_datasource/local_database.dart';
import 'package:ai_health_companion/features/ai_chat/data/datasource/local_datasource/tables/message_table.dart';
import 'package:drift/drift.dart';

part 'messages_dao.g.dart';

@DriftAccessor(tables: [Messages])
class MessagesDao extends DatabaseAccessor<LocalDatabase>
    with _$MessagesDaoMixin {
  MessagesDao(super.db);

  Future<List<Message>> getAllMessages() =>
      (select(messages)..orderBy([(m) => OrderingTerm.asc(m.createdAt)])).get();

  Future<void> upsertMessage(MessagesCompanion message) =>
      into(messages).insertOnConflictUpdate(message);

  Future<void> upsertAll(List<MessagesCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(messages, rows));

  Future<void> clearAll() => delete(messages).go();

  Stream<List<Message>> watchAllMessages() => (select(
    messages,
  )..orderBy([(m) => OrderingTerm.asc(m.createdAt)])).watch();
}
