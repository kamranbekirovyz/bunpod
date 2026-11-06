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

  /// The followed channels the feeds were last kept in step with.
  Set<int>? _channels;

  FeedLocalData get _local => locator<FeedLocalData>();

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

  /// Puts every cached feed in the state at once, so each tab opens
  /// instantly.
  Future<void> restore() async {
    final Map<int?, List<Episode>> cached = await _local.feeds();

    emit(
      FeedState(
        feeds: {
          for (final MapEntry(:key, :value) in cached.entries) key: Feed(value),
          ...state.feeds,
        },
      ),
    );
  }

  Future<void> refresh() {
    return _sync(channelId).timeout(_refreshTimeout, onTimeout: () {});
  }

  /// Keeps the feeds in step with the subscriptions. Unfollowed channels
  /// lose their feeds, and "All" syncs again to pick up or shed episodes.
  Future<void> syncChannels(List<Channel> channels) async {
    final Set<int> ids = {for (final Channel channel in channels) ?channel.id};
    final Set<int>? previous = _channels;
    _channels = ids;

    if (previous == null || setEquals(previous, ids)) return;

    final Set<int> removed = previous.difference(ids);
    _opened.removeAll(removed);
    emit(
      FeedState(
        feeds: {...state.feeds}..removeWhere((id, _) => removed.contains(id)),
      ),
    );
    await _local.removeFeeds(removed);

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

  /// Shows the cached copy right away, then syncs it with the server.
  Future<void> _open(int? channelId) async {
    if (!_opened.add(channelId)) return;

    if (state.feedOf(channelId) == null) {
      final List<Episode>? cached = await _local.feed(channelId: channelId);
      if (cached != null && state.feedOf(channelId) == null) {
        emit(state.withFeed(channelId, Feed(cached)));
      }
    }

    await _sync(channelId);
  }

  Future<void> _sync(int? channelId) async {
    try {
      final List<Episode> fresh = await locator<FeedRemoteData>().feed(
        channelId: channelId,
      );
      await _local.cacheFeed(fresh, channelId: channelId);

      final Feed? shown = state.feedOf(channelId);
      final Feed feed = Feed(
        fresh,
        arrived: shown == null ? const [] : _arrived(shown.episodes, fresh),
      );

      emit(state.withFeed(channelId, feed));
    } catch (error) {
      logarte.log('feed $channelId sync failed: $error');
    }
  }

  List<Episode> _arrived(List<Episode> shown, List<Episode> fresh) {
    final Set<int?> known = {for (final Episode episode in shown) episode.id};

    return [
      for (final Episode episode in fresh)
        if (!known.contains(episode.id)) episode,
    ];
  }
}
