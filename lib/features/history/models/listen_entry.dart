import 'package:bunpod/bunpod.dart';

/// One sitting: an episode, when it was played, and how much of it was heard.
class ListenEntry {
  const ListenEntry({
    required this.episode,
    required this.playedAt,
    required this.listened,
  });

  final Episode episode;
  final DateTime playedAt;
  final Duration listened;
}
