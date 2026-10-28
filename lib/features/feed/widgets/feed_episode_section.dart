import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';

class FeedEpisodeSection extends StatelessWidget {
  const FeedEpisodeSection({
    super.key,
    required this.bucket,
    required this.episodes,
    required this.first,
    required this.playingId,
    required this.onTap,
  });

  final Bucket bucket;
  final List<Episode> episodes;
  final bool first;
  final int? playingId;
  final ValueChanged<Episode> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeedSectionHeader(
          label: bucket.label,
          count: episodes.length,
          topPadding: first ? 16 : 32,
        ),
        for (final Episode episode in episodes)
          Padding(
            padding: const .fromLTRB(16, 0, 16, 8),
            child: FeedEpisodeCard(
              episode: episode,
              playing: episode.id == playingId,
              onTap: () {
                onTap(episode);
              },
            ),
          ),
      ],
    );
  }
}
