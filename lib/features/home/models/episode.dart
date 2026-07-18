import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';

class Episode {
  const Episode({
    required this.bucket,
    required this.channel,
    required this.host,
    required this.title,
    required this.date,
    required this.seed,
    required this.image,
    required this.total,
    required this.listened,
    this.playing = false,
  });

  final Bucket bucket;
  final String channel;
  final String host;
  final String title;
  final String date;
  final Color seed;
  final String image;
  final Duration total;
  final Duration listened;
  final bool playing;

  double get progress =>
      total.inSeconds == 0 ? 0 : listened.inSeconds / total.inSeconds;

  ColorScheme scheme(BuildContext context) => ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Theme.of(context).brightness,
    dynamicSchemeVariant: DynamicSchemeVariant.content,
  );
}
