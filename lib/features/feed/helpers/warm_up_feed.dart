import 'dart:async';

import 'package:bunpod/bunpod.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

const Duration _budget = Duration(seconds: 3);
const int _covers = 8;

/// Gets the feed's first frame ready behind the launch screen, so it opens
/// complete instead of filling in. Never waits past [_budget].
Future<void> warmUpFeed(BuildContext context) async {
  try {
    await _warmUp(context).timeout(_budget);
  } catch (error) {
    logarte.log('feed warm up cut short: $error');
  }
}

Future<void> _warmUp(BuildContext context) async {
  final SubscriptionsCubit subscriptions = locator<SubscriptionsCubit>();
  final FeedCubit feed = locator<FeedCubit>();

  await subscriptions.restore();
  if (subscriptions.state == null) subscriptions.load().ignore();

  await feed.restore();

  // With a cache, the feed page starts the sync. Without one there is
  // nothing to show yet, so fetch it here.
  final bool cached = feed.state.feedOf(null) != null;
  if (!cached) feed.setChannelId(null);

  await Future.wait([
    _until(subscriptions, (channels) => channels != null),
    if (!cached) _until(feed, (state) => state.feedOf(null) != null),
  ]);

  if (!context.mounted) return;

  final Episode? last = locator<PreferencesLocalData>().lastEpisode;
  final List<Episode> episodes = feed.state.feedOf(null)?.episodes ?? [];

  final Set<String> urls = {
    ?last?.cover,
    for (final Channel channel in subscriptions.state ?? []) ?channel.image,
    for (final Episode episode in episodes.take(_covers)) episode.cover,
  }..remove('');

  await Future.wait([
    for (final String url in urls)
      precacheImage(ExtendedNetworkImageProvider(url, cache: true), context),
  ]);
}

Future<void> _until<S>(Cubit<S> cubit, bool Function(S state) test) async {
  if (test(cubit.state)) return;

  await cubit.stream.firstWhere(test);
}
