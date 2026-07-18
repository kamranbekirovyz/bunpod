import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';

/// An editorial shelf of the catalog: a name, a seed color that tints its
/// card (mirroring how [Channel.scheme] tints channel surfaces), and the
/// channels filed under it.
class ExploreCategory {
  const ExploreCategory({
    required this.name,
    required this.seed,
    required this.channelNames,
  });

  final String name;
  final Color seed;
  final List<String> channelNames;

  /// Per-category color scheme, the same mechanism episodes and channels use
  /// so every tinted surface in the app speaks one color language.
  ColorScheme scheme(BuildContext context) => ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Theme.of(context).brightness,
    dynamicSchemeVariant: DynamicSchemeVariant.content,
  );

  /// The catalog channels filed under this category, skipping any name that
  /// no longer resolves.
  List<Channel> get channels => <Channel>[
    for (final String name in channelNames)
      if (channelByName(name) case final Channel channel) channel,
  ];
}
