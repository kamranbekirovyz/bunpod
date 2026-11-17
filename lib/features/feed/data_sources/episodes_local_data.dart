import 'package:bunpod/bunpod.dart';
import 'package:drift/drift.dart';

class EpisodesLocalData {
  const EpisodesLocalData();

  AppDatabase get database => locator<AppDatabase>();

  Future<RssFeed?> feed(String feedUrl) {
    return (database.select(database.rssFeeds)..where((feed) {
          return feed.feedUrl.equals(feedUrl);
        }))
        .getSingleOrNull();
  }

  Future<bool> refreshed(List<String> feedUrls) async {
    final RssFeed? any =
        await (database.select(database.rssFeeds)
              ..where((feed) {
                return feed.feedUrl.isIn(feedUrls) &
                    feed.refreshedAt.isNotNull();
              })
              ..limit(1))
            .getSingleOrNull();

    return any != null;
  }

  // Stored episodes are updated, never removed.
  Future<void> saveFeed({
    required String feedUrl,
    required Channel channel,
    required ParsedFeed parsed,
    String? etag,
    String? lastModified,
  }) {
    return database.transaction(() async {
      await database
          .into(database.rssFeeds)
          .insertOnConflictUpdate(
            RssFeedsCompanion.insert(
              feedUrl: feedUrl,
              channelId: Value(channel.id),
              title: Value(channel.title ?? parsed.title),
              image: Value(channel.image ?? parsed.image),
              etag: Value(etag),
              lastModified: Value(lastModified),
              refreshedAt: Value(DateTime.now()),
            ),
          );

      await database.batch((batch) {
        batch.insertAllOnConflictUpdate(database.rssEpisodes, [
          for (final Episode episode in parsed.episodes)
            RssEpisodesCompanion.insert(
              feedUrl: feedUrl,
              guid: episode.id!,
              title: Value(episode.title),
              description: Value(episode.description),
              image: Value(episode.image),
              audioUrl: Value(episode.audioUrl),
              audioBytes: Value(episode.audioBytes),
              duration: Value(episode.duration),
              publishedAt: Value(episode.publishedAt),
            ),
        ]);
      });
    });
  }

  Future<void> touchFeed(String feedUrl) {
    return (database.update(database.rssFeeds)..where((feed) {
          return feed.feedUrl.equals(feedUrl);
        }))
        .write(RssFeedsCompanion(refreshedAt: Value(DateTime.now())));
  }

  Future<List<Episode>> episodes({
    required List<String> feedUrls,
    int offset = 0,
    int limit = 50,
  }) async {
    final query =
        database.select(database.rssEpisodes).join([
            innerJoin(
              database.rssFeeds,
              database.rssFeeds.feedUrl.equalsExp(
                database.rssEpisodes.feedUrl,
              ),
            ),
            leftOuterJoin(
              database.episodeProgress,
              database.episodeProgress.feedUrl.equalsExp(
                    database.rssEpisodes.feedUrl,
                  ) &
                  database.episodeProgress.guid.equalsExp(
                    database.rssEpisodes.guid,
                  ),
            ),
          ])
          ..where(database.rssEpisodes.feedUrl.isIn(feedUrls))
          ..orderBy([OrderingTerm.desc(database.rssEpisodes.publishedAt)])
          ..limit(limit, offset: offset);

    return [
      for (final TypedResult row in await query.get())
        _episode(
          row.readTable(database.rssEpisodes),
          row.readTable(database.rssFeeds),
          row.readTableOrNull(database.episodeProgress),
        ),
    ];
  }

  Future<void> removeFeeds(Set<String> feedUrls) {
    return database.transaction(() async {
      await (database.delete(database.rssEpisodes)..where((episode) {
            return episode.feedUrl.isIn(feedUrls);
          }))
          .go();
      await (database.delete(database.rssFeeds)..where((feed) {
            return feed.feedUrl.isIn(feedUrls);
          }))
          .go();
    });
  }

  Future<void> clear() {
    return database.transaction(() async {
      await database.delete(database.rssEpisodes).go();
      await database.delete(database.rssFeeds).go();
      await database.delete(database.episodeProgress).go();
    });
  }

  Episode _episode(
    RssEpisode episode,
    RssFeed feed,
    EpisodeProgressData? progress,
  ) {
    return Episode(
      id: episode.guid,
      feedUrl: episode.feedUrl,
      channelId: feed.channelId,
      channel: Channel(
        id: feed.channelId,
        title: feed.title,
        image: feed.image,
        feedUrl: feed.feedUrl,
      ),
      title: episode.title,
      description: episode.description,
      image: episode.image,
      publishedAt: episode.publishedAt,
      duration: episode.duration,
      audioUrl: episode.audioUrl,
      audioBytes: episode.audioBytes,
      position: progress?.position,
      completed: progress?.completed,
    );
  }
}
