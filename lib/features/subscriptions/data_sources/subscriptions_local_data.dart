import 'dart:convert';

import 'package:bunpod/bunpod.dart';
import 'package:drift/drift.dart';

/// The last synced subscriptions, so the feed's tabs show on open.
class SubscriptionsLocalData {
  const SubscriptionsLocalData();

  AppDatabase get database => locator<AppDatabase>();

  /// Empty when never synced.
  Future<List<Channel>> subscriptions() async {
    final List<CachedSubscription> rows =
        await (database.select(database.cachedSubscriptions)..orderBy([
              (channel) => OrderingTerm.asc(channel.sortOrder),
            ]))
            .get();

    return [
      for (final CachedSubscription row in rows)
        Channel.fromJson(jsonDecode(row.data) as Map<String, dynamic>),
    ];
  }

  Future<void> cacheSubscriptions(List<Channel> channels) {
    return database.transaction(() async {
      await database.delete(database.cachedSubscriptions).go();

      await database.batch((batch) {
        batch.insertAll(database.cachedSubscriptions, [
          for (final (int i, Channel channel) in channels.indexed)
            if (channel.id case final int id)
              CachedSubscriptionsCompanion.insert(
                channelId: Value(id),
                sortOrder: i,
                data: jsonEncode(channel.toJson()),
              ),
        ]);
      });
    });
  }

  Future<void> clear() => database.delete(database.cachedSubscriptions).go();
}
