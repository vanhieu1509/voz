import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'app_database.g.dart';

class Threads extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get author => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class Posts extends Table {
  TextColumn get id => text()();
  TextColumn get threadId => text()();
  TextColumn get author => text()();
  TextColumn get content => text()();
  DateTimeColumn get postedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text()();
  TextColumn get avatarUrl => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class Pages extends Table {
  TextColumn get id => text()();
  TextColumn get threadId => text()();
  IntColumn get page => integer()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>>? get primaryKey => {key};
}

class WatchedThreads extends Table {
  TextColumn get threadId => text()();
  DateTimeColumn get watchedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {threadId};
}

@DriftDatabase(tables: [Threads, Posts, Users, Pages, Settings, WatchedThreads])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;
}
