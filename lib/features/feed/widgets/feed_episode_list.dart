import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:material_ui/material_ui.dart';

class FeedEpisodeList extends StatelessWidget {
  const FeedEpisodeList({
    super.key,
    required this.feed,
    required this.controller,
    required this.topPadding,
  });

  final Feed? feed;
  final ScrollController controller;

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final Feed? feed = this.feed;

    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: topPadding),
        ),
        if (feed == null)
          const _FeedLoading()
        else ...[
          for (final (int i, FeedDateGroup group) in feed.groups.indexed)
            FeedDateGroupSliver(
              key: ValueKey<Bucket>(group.bucket),
              group: group,
              arrivals: feed.arrivals,
              first: i == 0,
            ),
          SliverToBoxAdapter(
            child: 112.gap,
          ),
        ],
      ],
    );
  }
}

class _FeedLoading extends StatelessWidget {
  const _FeedLoading();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: LoadingIndicator(),
      ),
    );
  }
}
