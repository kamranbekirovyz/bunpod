import 'package:bunpod/bunpod.dart';
import 'package:drift/drift.dart';

class SubscriptionsLocalData {
  const SubscriptionsLocalData();

  AppDatabase get database => locator<AppDatabase>();

  Future<List<Channel>> subscriptions() async {
    final List<Subscription> rows =
        await (database.select(database.subscriptions)..orderBy([
              (row) {
                return OrderingTerm(
                  expression: row.lastEpisodeAt,
                  mode: .desc,
                  nulls: .last,
                );
              },
            ]))
            .get();

    return [
      for (final Subscription row in rows) _channel(row),
    ];
  }

  Future<bool> isSubscribed(int channelId) async {
    final Subscription? row =
        await (database.select(database.subscriptions)..where((row) {
              return row.channelId.equals(channelId);
            }))
            .getSingleOrNull();

    return row != null;
  }

  Future<Channel?> channel({int? id, int? appleId}) async {
    if (id == null && appleId == null) return null;

    final Subscription? row =
        await (database.select(database.subscriptions)..where((row) {
              return id != null
                  ? row.channelId.equals(id)
                  : row.appleId.equals(appleId!);
            }))
            .getSingleOrNull();

    return row == null ? null : _channel(row);
  }

  // Missing fields keep what Podcast Index gave at follow time.
  Future<void> updateFromFeed(String feedUrl, ParsedFeed parsed) {
    final DateTime? newest = parsed.episodes.firstOrNull?.publishedAt;

    return (database.update(database.subscriptions)..where((row) {
          return row.feedUrl.equals(feedUrl);
        }))
        .write(
          SubscriptionsCompanion(
            title: Value.absentIfNull(parsed.title),
            author: Value.absentIfNull(parsed.author),
            description: Value.absentIfNull(parsed.description),
            image: Value.absentIfNull(parsed.image),
            language: Value.absentIfNull(parsed.language),
            lastEpisodeAt: Value.absentIfNull(newest),
          ),
        );
  }

  // Channels without an id or feed can't be followed, so they're skipped.
  Future<void> subscribe(List<Channel> channels) {
    return database.batch((batch) {
      batch.insertAllOnConflictUpdate(database.subscriptions, [
        for (final Channel channel in channels)
          if ((channel.id, channel.feedUrl) case (
            final int id,
            final String feedUrl,
          ))
            SubscriptionsCompanion.insert(
              channelId: Value(id),
              appleId: Value(channel.appleId),
              feedUrl: feedUrl,
              title: Value(channel.title),
              author: Value(channel.author),
              description: Value(channel.description),
              image: Value(channel.image),
              language: Value(channel.language),
              lastEpisodeAt: Value(channel.lastEpisodeAt),
            ),
      ]);
    });
  }

  Future<void> unsubscribe(int channelId) {
    return (database.delete(database.subscriptions)..where((row) {
          return row.channelId.equals(channelId);
        }))
        .go();
  }

  Channel _channel(Subscription row) {
    return Channel(
      id: row.channelId,
      appleId: row.appleId,
      feedUrl: row.feedUrl,
      title: row.title,
      author: row.author,
      description: row.description,
      image: row.image,
      language: row.language,
      lastEpisodeAt: row.lastEpisodeAt,
    );
  }
}
