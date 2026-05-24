import 'package:drift/drift.dart';

/// Drift table for persisted chat messages.
/// Uses string columns for role and type to stay decoupled from domain enums.
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get role => text()(); // 'user' | 'assistant' | 'system'
  TextColumn get content => text()();
  TextColumn get type => text().withDefault(const Constant('text'))();
  IntColumn get severityValue => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
