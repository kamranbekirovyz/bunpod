import 'package:bunpod_flutter/bunpod_flutter.dart';

/// The shows the user follows. Mock-only: every catalog channel starts
/// subscribed, matching how [ChannelPage] opens on `Subscribed`. Real
/// subscription storage lands later.
List<Channel> get mockSubscriptions => mockChannels;

/// Episodes on [channel] the user hasn't started yet.
int newEpisodeCount(Channel channel) {
  return channel.episodes
      .where((Episode episode) => episode.listened == Duration.zero)
      .length;
}
