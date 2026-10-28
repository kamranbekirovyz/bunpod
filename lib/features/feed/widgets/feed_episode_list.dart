import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/material.dart';

class FeedEpisodeList extends StatelessWidget {
  const FeedEpisodeList({
    super.key,
    required this.episodes,
    required this.playingId,
    required this.onTap,
  });

  final List<Episode>? episodes;
  final int? playingId;
  final ValueChanged<Episode> onTap;

  @override
  Widget build(BuildContext context) {
    final Map<Bucket, List<Episode>> groups = {};

    for (final Episode episode in episodes ?? []) {
      (groups[episode.bucket] ??= []).add(episode);
    }

    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        if (episodes == null)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: LoadingIndicator(),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 32),
            sliver: SliverList.list(
              children: [
                for (final MapEntry(key: bucket, value: group)
                    in groups.entries)
                  FeedEpisodeSection(
                    bucket: bucket,
                    episodes: group,
                    first: bucket == groups.keys.first,
                    playingId: playingId,
                    onTap: onTap,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
