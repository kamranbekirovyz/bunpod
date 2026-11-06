import 'dart:convert';

import 'package:bunpod/bunpod.dart';
import 'package:drift/drift.dart';

class FeedLocalData {
  const FeedLocalData();

  AppDatabase get database => locator<AppDatabase>();

  static int _key(int? channelId) => channelId ?? 0;
  static int? _channelId(int key) => key == 0 ? null : key;

  /// Every synced feed, by channel.
  Future<Map<int?, List<Episode>>> feeds() async {
    final List<CachedFeed> synced = await database
        .select(database.cachedFeeds)
        .get();

    final Map<int?, List<Episode>> feeds = {
      for (final CachedFeed feed in synced) _channelId(feed.feedKey): [],
    };

    for (final (int key, Episode episode) in await _entries()) {
      feeds[_channelId(key)]?.add(episode);
    }

    return feeds;
  }

  /// Null when this feed was never synced.
  Future<List<Episode>?> feed({int? channelId}) async {
    final int key = _key(channelId);

    final CachedFeed? synced =
        await (database.select(
              database.cachedFeeds,
            )..where(($CachedFeedsTable feed) {
              return feed.feedKey.equals(key);
            }))
            .getSingleOrNull();
    if (synced == null) return null;

    return [for (final (_, Episode episode) in await _entries(key)) episode];
  }

  Future<void> cacheFeed(List<Episode> episodes, {int? channelId}) {
    final int key = _key(channelId);

    return database.transaction(() async {
      await (database.delete(
            database.cachedFeedEntries,
          )..where(($CachedFeedEntriesTable entry) {
            return entry.feedKey.equals(key);
          }))
          .go();

      await database
          .into(database.cachedFeeds)
          .insert(
            CachedFeedsCompanion.insert(feedKey: Value(key)),
            mode: .insertOrIgnore,
          );

      await database.batch((batch) {
        for (final (int i, Episode episode) in episodes.indexed) {
          final int? id = episode.id;
          if (id == null) continue;

          batch.insert(
            database.cachedEpisodes,
            CachedEpisodesCompanion.insert(
              episodeId: Value(id),
              data: jsonEncode(episode.toJson()),
            ),
            mode: .insertOrReplace,
          );
          batch.insert(
            database.cachedFeedEntries,
            CachedFeedEntriesCompanion.insert(
              feedKey: key,
              episodeId: id,
              sortOrder: i,
            ),
            mode: .insertOrReplace,
          );
        }
      });

      await _dropOrphans();
    });
  }

  /// Drops the feeds of channels no longer followed.
  Future<void> removeFeeds(Set<int> channelIds) {
    return database.transaction(() async {
      await (database.delete(
            database.cachedFeedEntries,
          )..where(($CachedFeedEntriesTable entry) {
            return entry.feedKey.isIn(channelIds);
          }))
          .go();
      await (database.delete(
            database.cachedFeeds,
          )..where(($CachedFeedsTable feed) {
            return feed.feedKey.isIn(channelIds);
          }))
          .go();

      await _dropOrphans();
    });
  }

  Future<void> clear() {
    return database.transaction(() async {
      await database.delete(database.cachedFeedEntries).go();
      await database.delete(database.cachedEpisodes).go();
      await database.delete(database.cachedFeeds).go();
    });
  }

  /// Ordered episodes of one feed, or of every feed when [key] is null.
  Future<List<(int, Episode)>> _entries([int? key]) async {
    final JoinedSelectStatement<HasResultSet, dynamic> query = database
        .select(database.cachedFeedEntries)
        .join([
          innerJoin(
            database.cachedEpisodes,
            database.cachedEpisodes.episodeId.equalsExp(
              database.cachedFeedEntries.episodeId,
            ),
          ),
        ]);

    if (key != null) {
      query.where(database.cachedFeedEntries.feedKey.equals(key));
    }
    query.orderBy([
      OrderingTerm.asc(database.cachedFeedEntries.feedKey),
      OrderingTerm.asc(database.cachedFeedEntries.sortOrder),
    ]);

    return [
      for (final TypedResult row in await query.get())
        (
          row.readTable(database.cachedFeedEntries).feedKey,
          _decode(row.readTable(database.cachedEpisodes).data),
        ),
    ];
  }

  /// Episodes no feed lists anymore.
  Future<void> _dropOrphans() {
    return database.customStatement(
      'DELETE FROM cached_episodes WHERE episode_id NOT IN '
      '(SELECT episode_id FROM cached_feed_entries)',
    );
  }

  Episode _decode(String data) {
    return Episode.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }
}
