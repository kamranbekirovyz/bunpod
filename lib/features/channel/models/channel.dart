import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';

/// A podcast channel. Its identity (name, host, seed, cover) is derived from the
/// episodes that belong to it — see [mockChannels] — so there is a single source
/// of truth. Only the editorial [description] is channel-level data.
class Channel {
  const Channel({
    required this.name,
    required this.host,
    required this.seed,
    required this.image,
    required this.description,
  });

  final String name;
  final String host;
  final Color seed;
  final String image;
  final String description;

  /// Per-channel color scheme, mirroring [Episode.scheme] so the channel page
  /// tints to the same palette as its episodes.
  ColorScheme scheme(BuildContext context) => ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Theme.of(context).brightness,
    dynamicSchemeVariant: DynamicSchemeVariant.content,
  );

  /// Episodes that belong to this channel, in feed order.
  List<Episode> get episodes =>
      mockEpisodes.where((Episode e) => e.channel == name).toList();
}
