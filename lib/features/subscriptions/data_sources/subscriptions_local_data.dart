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
