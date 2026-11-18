import 'dart:async';

import 'package:bunpod/bunpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class FeedCubit extends Cubit<Map<int?, Feed>> {
  FeedCubit() : super(const {}) {
    _subscriptions = [
      _channelId.listen(_open),
      _channelId.pairwise().listen(_settle),
    ];
  }

  late final List<StreamSubscription<Object?>> _subscriptions;

  List<Channel>? _channels;

  Future<void>? _running;

  final _channelId = BehaviorSubject<int?>();
  final _syncing = BehaviorSubject<bool>.seeded(false);

  Stream<int?> get channelId$ => _channelId.stream;
  Stream<bool> get syncing$ => _syncing.stream;

  int? get channelId => _channelId.valueOrNull;
  bool get syncing => _syncing.value;

  void setSyncing(bool value) {
    _syncing.add(value);
  }

  void setChannelId(int? channelId) {
    _channelId.add(channelId);
  }

  @override
  Future<void> close() {
    for (final StreamSubscription<Object?> subscription in _subscriptions) {
      subscription.cancel();
    }
    _channelId.close();
    _syncing.close();
    return super.close();
  }

  /// instantly.
  Future<void> restore(List<Channel> channels) async {
    _channels = channels;

    final Map<int?, Feed> stored = {};
    for (final int? id in [null, for (final Channel c in channels) c.id]) {
      final List<Episode>? episodes = await _stored(id);
      if (episodes != null) stored[id] = Feed(episodes);
    }

    emit({...stored, ...state});
  }

  Future<void> refresh({
    required bool force,
  }) {
    return sync(force: force).timeout(
      AppValues.feedRefreshTimeout,
      onTimeout: () {},
    );
  }

  /// Keeps the feeds in step with the subscriptions. Unfollowed channels
  /// lose their feeds, and "All" syncs again to pick up or shed episodes.
  Future<void> syncChannels(List<Channel> channels) async {
    final List<Channel>? previous = _channels;
    _channels = channels;

    if (previous == null || setEquals(_ids(previous), _ids(channels))) return;

    final Set<int> kept = _ids(channels);
    final List<Channel> removed = [
      for (final Channel channel in previous)
        if (!kept.contains(channel.id)) channel,
    ];

    emit({...state}..removeWhere((id, _) => removed.any((c) => c.id == id)));
    await locator<EpisodesLocalData>().removeFeeds({
      for (final Channel channel in removed) ?channel.feedUrl,
    });

    // Running sync has old channels.
    await _running;
    await sync();
  }

  void clear() {
    _channels = null;
    emit(const {});
  }

  /// Arrivals play once, so a revisited tab doesn't replay them.
  void _settle(List<int?> pair) {
    final int? left = pair.first;

    final Feed? feed = state[left];
    if (feed != null) emit({...state, left: feed.settled});
  }

  Future<void> _open(int? channelId) async {
    // Running sync fills it.
    await _running;
    if (state[channelId] != null) return;

    final Feed feed = Feed(await _episodes(channelId));
    emit({...state, channelId: feed});
  }

  Future<void> sync({bool force = false}) {
    return _running ??= _fetch(force).whenComplete(() => _running = null);
  }

  Future<void> _fetch(bool force) async {
    setSyncing(true);
    try {
      await locator<FeedSync>().syncAll(_channels ?? const [], force: force);
    } finally {
      setSyncing(false);
    }

    for (final int? id in [null, ..._ids(_channels ?? const [])]) {
      final List<Episode> fresh = await _episodes(id);
      final Feed? shown = state[id];

      final Feed feed = Feed(
        fresh,
        arrived: shown == null ? const [] : _arrived(shown.episodes, fresh),
      );
      emit({...state, id: feed});
    }
  }

  Future<List<Episode>> _episodes(int? channelId) {
    return locator<EpisodesLocalData>().episodes(
      feedUrls: _feedUrls(_channelsOf(channelId)),
    );
  }

  Future<List<Episode>?> _stored(int? channelId) async {
    final List<String> feedUrls = _feedUrls(_channelsOf(channelId));

    if (!await locator<EpisodesLocalData>().refreshed(feedUrls)) return null;

    return locator<EpisodesLocalData>().episodes(feedUrls: feedUrls);
  }

  List<Channel> _channelsOf(int? channelId) {
    final List<Channel> channels = _channels ?? const [];
    if (channelId == null) return channels;

    return [
      for (final Channel channel in channels)
        if (channel.id == channelId) channel,
    ];
  }

  List<String> _feedUrls(List<Channel> channels) {
    return [for (final Channel channel in channels) ?channel.feedUrl];
  }

  Set<int> _ids(List<Channel> channels) {
    return {for (final Channel channel in channels) ?channel.id};
  }

  List<Episode> _arrived(List<Episode> shown, List<Episode> fresh) {
    final Set<String?> known = {
      for (final Episode episode in shown) episode.id,
    };

    return [
      for (final Episode episode in fresh)
        if (!known.contains(episode.id)) episode,
    ];
  }
}
