import 'package:drift/drift.dart';
import 'database_connection.dart';

part 'app_database.g.dart';

class LocalStorages extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get name => text()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get qrCode => text()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {id};
}

class LocalClothes extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get storageId => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get name => text().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueueItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operation => text()();
  TextColumn get table => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [LocalStorages, LocalClothes, SyncQueueItems])
class AppDatabase extends _$AppDatabase {
  static AppDatabase? _instance;
  static AppDatabase get instance => _instance ??= AppDatabase._();
  AppDatabase._() : super(openAppDatabase());

  @override
  int get schemaVersion => 1;
}
