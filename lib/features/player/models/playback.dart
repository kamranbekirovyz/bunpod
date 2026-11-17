import 'package:bunpod/bunpod.dart';

class Playback {
  const Playback({
    this.episode,
    this.playing = false,
    this.loading = false,
    this.positions = const {},
  });

  final Episode? episode;
  final bool playing;
  final bool loading;
  final Map<String, Duration> positions;
}
