import 'package:bunpod/bunpod.dart';

/// One loaded feed, already grouped by date.
class Feed {
  Feed(this.episodes) : groups = _group(episodes);

  final List<Episode> episodes;
  final List<FeedDateGroup> groups;

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
