import 'package:bunpod/bunpod.dart';

/// The shows the user follows. Mock-only: every catalog channel starts
/// subscribed, matching how [ChannelPage] opens on `Subscribed`. Real
/// subscription storage lands later.
List<MockChannel> get mockSubscriptions => mockChannels;

/// Episodes on [channel] the user hasn't started yet.
int newEpisodeCount(MockChannel channel) {
  return channel.episodes
      .where((Episode episode) => episode.listened == Duration.zero)
      .length;
}
