import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

class FeedDateGroupSliver extends StatelessWidget {
  const FeedDateGroupSliver({
    super.key,
    required this.group,
    required this.arrivals,
    required this.first,
  });

  final FeedDateGroup group;
  final Map<int, int> arrivals;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final List<Episode> episodes = group.episodes;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: FeedSectionHeader(
            label: group.bucket.label,
            count: episodes.length,
            topPadding: first ? 16 : 32,
          ),
        ),
        SliverPadding(
          padding: const .symmetric(horizontal: 16),
          sliver: SliverList.builder(
            itemCount: episodes.length,
            // Keeps each card's state when new episodes push it down.
            findChildIndexCallback: (key) {
              final int index = episodes.indexWhere((episode) {
                return ValueKey<int?>(episode.id) == key;
              });

              return index < 0 ? null : index;
            },
            itemBuilder: (context, index) {
              final Episode episode = episodes[index];

              return FeedArrival(
                key: ValueKey<int?>(episode.id),
                order: arrivals[episode.id],
                child: Padding(
                  padding: const .only(bottom: 8),
                  child: FeedEpisodeCard(
                    episode: episode,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
