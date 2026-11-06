import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Feeds that have been cached.
class CachedFeeds extends Table {
  IntColumn get feedKey => integer()();

  @override
  Set<Column<Object>> get primaryKey => {feedKey};
}

/// Cached episodes.
class CachedEpisodes extends Table {
  IntColumn get episodeId => integer()();
  TextColumn get data => text()();

  @override
  Set<Column<Object>> get primaryKey => {episodeId};
}

/// The episodes in each feed, in order.
class CachedFeedEntries extends Table {
  IntColumn get feedKey => integer().references(CachedFeeds, #feedKey)();
  IntColumn get episodeId => integer().references(CachedEpisodes, #episodeId)();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {feedKey, episodeId};
}

/// Cached subscriptions.
class CachedSubscriptions extends Table {
  IntColumn get channelId => integer()();
  IntColumn get sortOrder => integer()();
  TextColumn get data => text()();

  @override
  Set<Column<Object>> get primaryKey => {channelId};
}

@DriftDatabase(
  tables: [
    CachedFeeds,
    CachedEpisodes,
    CachedFeedEntries,
    CachedSubscriptions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'bunpod'));

  @override
  int get schemaVersion => 1;
}
