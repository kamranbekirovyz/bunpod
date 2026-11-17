import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class RssFeeds extends Table {
  TextColumn get feedUrl => text()();
  IntColumn get channelId => integer().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get image => text().nullable()();
  TextColumn get etag => text().nullable()();
  TextColumn get lastModified => text().nullable()();
  DateTimeColumn get refreshedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {feedUrl};
}

@TableIndex(name: 'rss_episodes_feed_date', columns: {#feedUrl, #publishedAt})
@TableIndex(name: 'rss_episodes_date', columns: {#publishedAt})
class RssEpisodes extends Table {
  TextColumn get feedUrl => text()();
  TextColumn get guid => text()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get image => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  IntColumn get audioBytes => integer().nullable()();
  IntColumn get duration => integer().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {feedUrl, guid};
}

// Apart from episodes, so dropping a feed keeps progress.
class EpisodeProgress extends Table {
  TextColumn get feedUrl => text()();
  TextColumn get guid => text()();
  IntColumn get position => integer()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {feedUrl, guid};
}

class Subscriptions extends Table {
  IntColumn get channelId => integer()();
  IntColumn get appleId => integer().nullable()();
  TextColumn get feedUrl => text()();
  TextColumn get title => text().nullable()();
  TextColumn get author => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get image => text().nullable()();
  TextColumn get language => text().nullable()();
  DateTimeColumn get lastEpisodeAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {channelId};
}

@DriftDatabase(
  tables: [
    RssFeeds,
    RssEpisodes,
    EpisodeProgress,
    Subscriptions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'bunpod'));

  @override
  int get schemaVersion => 2;

  // cached_subscriptions stays for LegacySubscriptionsMigration.
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          for (final String table in const [
            'cached_feed_entries',
            'cached_episodes',
            'cached_feeds',
          ]) {
            await customStatement('DROP TABLE IF EXISTS $table');
          }
          await migrator.createAll();
        }
      },
    );
  }
}
