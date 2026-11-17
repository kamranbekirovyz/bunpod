import 'dart:convert';

import 'package:bunpod/bunpod.dart';
import 'package:drift/drift.dart';

class LegacySubscriptionsMigration {
  const LegacySubscriptionsMigration();

  static const String _table = 'cached_subscriptions';
  static const int _concurrency = 10;

  AppDatabase get _database => locator<AppDatabase>();

  Future<void> run() async {
    if (!await _hasLegacyTable()) return;

    final List<Channel> legacy = await _legacyChannels();
    final List<Channel?> found = await mapWithLimit(
      legacy,
      _concurrency,
      _lookUp,
    );
    final List<Channel> moved = found.nonNulls.toList();

    await locator<SubscriptionsLocalData>().subscribe(moved);
    await _forget([
      for (final (int i, Channel? channel) in found.indexed)
        if (channel != null) ?legacy[i].id,
    ]);

    logarte.log(
      'legacy subscriptions: ${moved.length} of ${legacy.length} moved',
    );
  }

  Future<Channel?> _lookUp(Channel channel) async {
    final PodcastIndexRemoteData podcastIndex =
        locator<PodcastIndexRemoteData>();

    try {
      final int? id = channel.id;
      final int? appleId = channel.appleId;

      return (id == null ? null : await podcastIndex.byFeedId(id)) ??
          (appleId == null ? null : await podcastIndex.byItunesId(appleId));
    } catch (error) {
      logarte.log('legacy subscription ${channel.id} not moved: $error');
      return null;
    }
  }

  Future<bool> _hasLegacyTable() async {
    final List<QueryRow> rows = await _database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
          variables: [Variable.withString(_table)],
        )
        .get();

    return rows.isNotEmpty;
  }

  Future<List<Channel>> _legacyChannels() async {
    final List<QueryRow> rows = await _database
        .customSelect('SELECT data FROM $_table')
        .get();

    return [
      for (final QueryRow row in rows)
        Channel.fromJson(jsonDecode(row.read<String>('data'))),
    ];
  }

  Future<void> _forget(List<int> ids) async {
    for (final int id in ids) {
      await _database.customStatement(
        'DELETE FROM $_table WHERE channel_id = ?',
        [id],
      );
    }

    final List<QueryRow> left = await _database
        .customSelect('SELECT 1 FROM $_table LIMIT 1')
        .get();

    if (left.isEmpty) await _database.customStatement('DROP TABLE $_table');
  }
}
