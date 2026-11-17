import 'dart:async';

import 'package:bunpod/bunpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(const FeedState()) {
    _subscriptions = [
      _channelId.listen(_open),
      _channelId.pairwise().listen(_settle),
    ];
  }

  static const Duration _refreshTimeout = Duration(seconds: 15);

  late final List<StreamSubscription<Object?>> _subscriptions;

  /// Channels opened this session. Each syncs once, then refreshes on pull.
  final Set<int?> _opened = {};

  List<Channel>? _channels;

  EpisodesLocalData get _local => locator<EpisodesLocalData>();

  FeedSync get _feedSync => locator<FeedSync>();

  final _channelId = BehaviorSubject<int?>();

  Stream<int?> get channelId$ => _channelId.stream;

  int? get channelId => _channelId.valueOrNull;

  void setChannelId(int? channelId) {
    _channelId.add(channelId);
  }

  @override
  Future<void> close() {
    for (final StreamSubscription<Object?> subscription in _subscriptions) {
      subscription.cancel();
    }
    _channelId.close();
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

    emit(FeedState(feeds: {...stored, ...state.feeds}));
  }

  Future<void> refresh() {
    return _sync(
      channelId,
      force: true,
    ).timeout(_refreshTimeout, onTimeout: () {});
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

    _opened.removeAll(removed.map((channel) => channel.id));
    emit(
      FeedState(
        feeds: {...state.feeds}
          ..removeWhere((id, _) => removed.any((c) => c.id == id)),
      ),
    );
    await _local.removeFeeds({
      for (final Channel channel in removed) ?channel.feedUrl,
    });

    await _sync(null);
  }

  void clear() {
    _channels = null;
    _opened.clear();
    emit(const FeedState());
  }

  /// Arrivals play once, so a revisited tab doesn't replay them.
  void _settle(List<int?> pair) {
    final int? left = pair.first;

    final Feed? feed = state.feedOf(left);
    if (feed != null) emit(state.withFeed(left, feed.settled));
  }

  Future<void> _open(int? channelId) async {
    if (!_opened.add(channelId)) return;

    if (state.feedOf(channelId) == null) {
      final List<Episode>? stored = await _stored(channelId);
      if (stored != null && state.feedOf(channelId) == null) {
        emit(state.withFeed(channelId, Feed(stored)));
      }
    }

    await _sync(channelId);
  }

  Future<void> _sync(int? channelId, {bool force = false}) async {
    final List<Channel> channels = _channelsOf(channelId);

    await _feedSync.syncAll(channels, force: force);

    final List<Episode> fresh = await _local.episodes(
      feedUrls: _feedUrls(channels),
    );

    final Feed? shown = state.feedOf(channelId);
    final Feed feed = Feed(
      fresh,
      arrived: shown == null ? const [] : _arrived(shown.episodes, fresh),
    );

    emit(state.withFeed(channelId, feed));
  }

  Future<List<Episode>?> _stored(int? channelId) async {
    final List<String> feedUrls = _feedUrls(_channelsOf(channelId));

    if (!await _local.refreshed(feedUrls)) return null;

    return _local.episodes(feedUrls: feedUrls);
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
