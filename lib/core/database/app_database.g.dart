// GENERATED CODE - placeholder for build runner.
// ignore_for_file: type=lint
part of 'app_database.dart';

class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);

  late final ThreadsTable threads = ThreadsTable(this);
  late final PostsTable posts = PostsTable(this);
  late final UsersTable users = UsersTable(this);
  late final PagesTable pages = PagesTable(this);
  late final SettingsTable settings = SettingsTable(this);
  late final WatchedThreadsTable watchedThreads = WatchedThreadsTable(this);

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables => [threads, posts, users, pages, settings, watchedThreads];
}

class ThreadsTable extends TableInfo<Threads, dynamic> {
  ThreadsTable(this.attachedDatabase, [String? alias]) : super(alias);

  final GeneratedDatabase attachedDatabase;

  @override
  Threads get asDslTable => Threads();

  @override
  String get actualTableName => 'threads';

  @override
  Set<GeneratedColumn> get $primaryKey => {};
}

class PostsTable extends TableInfo<Posts, dynamic> {
  PostsTable(this.attachedDatabase, [String? alias]) : super(alias);
  final GeneratedDatabase attachedDatabase;

  @override
  Posts get asDslTable => Posts();

  @override
  String get actualTableName => 'posts';

  @override
  Set<GeneratedColumn> get $primaryKey => {};
}

class UsersTable extends TableInfo<Users, dynamic> {
  UsersTable(this.attachedDatabase, [String? alias]) : super(alias);
  final GeneratedDatabase attachedDatabase;

  @override
  Users get asDslTable => Users();

  @override
  String get actualTableName => 'users';

  @override
  Set<GeneratedColumn> get $primaryKey => {};
}

class PagesTable extends TableInfo<Pages, dynamic> {
  PagesTable(this.attachedDatabase, [String? alias]) : super(alias);
  final GeneratedDatabase attachedDatabase;

  @override
  Pages get asDslTable => Pages();

  @override
  String get actualTableName => 'pages';

  @override
  Set<GeneratedColumn> get $primaryKey => {};
}

class SettingsTable extends TableInfo<Settings, dynamic> {
  SettingsTable(this.attachedDatabase, [String? alias]) : super(alias);
  final GeneratedDatabase attachedDatabase;

  @override
  Settings get asDslTable => Settings();

  @override
  String get actualTableName => 'settings';

  @override
  Set<GeneratedColumn> get $primaryKey => {};
}

class WatchedThreadsTable extends TableInfo<WatchedThreads, dynamic> {
  WatchedThreadsTable(this.attachedDatabase, [String? alias]) : super(alias);
  final GeneratedDatabase attachedDatabase;

  @override
  WatchedThreads get asDslTable => WatchedThreads();

  @override
  String get actualTableName => 'watched_threads';

  @override
  Set<GeneratedColumn> get $primaryKey => {};
}
