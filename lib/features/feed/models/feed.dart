import 'package:bunpod/bunpod.dart';

/// One loaded feed, already grouped by date.
class Feed {
  Feed(
    this.episodes, {
    List<Episode> arrived = const [],
  }) : groups = FeedDateGroup.group(episodes),
       arrivals = {
         for (final (int i, Episode episode) in arrived.indexed)
           if (episode.id case final String id) id: i,
       };

  final List<Episode> episodes;
  final List<FeedDateGroup> groups;

  /// Episodes new since the cached copy, by the order they arrive in.
  final Map<String, int> arrivals;

  /// The same feed with its arrivals already shown.
  Feed get settled => arrivals.isEmpty ? this : Feed(episodes);
}

class FeedDateGroup {
  const FeedDateGroup({
    required this.label,
    required this.episodes,
  });

  final String label;
  final List<Episode> episodes;

  static List<FeedDateGroup> group(List<Episode> episodes) {
    final Map<String, List<Episode>> groups = {};

    for (final Episode episode in episodes) {
      (groups[episode.bucket] ??= []).add(episode);
    }

    return [
      for (final MapEntry(key: label, value: group) in groups.entries)
        FeedDateGroup(label: label, episodes: group),
    ];
  }
}
