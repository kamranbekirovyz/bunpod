import 'package:bunpod/bunpod.dart';

/// One loaded feed, already grouped by date.
class Feed {
  Feed(
    this.episodes, {
    List<Episode> arrived = const [],
  }) : groups = _group(episodes),
       arrivals = {
         for (final (int i, Episode episode) in arrived.indexed)
           if (episode.id case final int id) id: i,
       };

  final List<Episode> episodes;
  final List<FeedDateGroup> groups;

  /// Episodes new since the cached copy, by the order they arrive in.
  final Map<int, int> arrivals;

  /// The same feed with its arrivals already shown.
  Feed get settled => arrivals.isEmpty ? this : Feed(episodes);

  static List<FeedDateGroup> _group(List<Episode> episodes) {
    final Map<Bucket, List<Episode>> groups = {};

    for (final Episode episode in episodes) {
      (groups[episode.bucket] ??= []).add(episode);
    }

    return [
      for (final MapEntry(key: bucket, value: group) in groups.entries)
        FeedDateGroup(bucket: bucket, episodes: group),
    ];
  }
}

class FeedDateGroup {
  const FeedDateGroup({
    required this.bucket,
    required this.episodes,
  });

  final Bucket bucket;
  final List<Episode> episodes;
}
