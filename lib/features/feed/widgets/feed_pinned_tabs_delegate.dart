import 'package:material_ui/material_ui.dart';

/// Keeps the channel tabs pinned under the app bar at a fixed height.
class FeedPinnedTabsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  FeedPinnedTabsDelegate({
    required this.child,
    required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox.expand(
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant FeedPinnedTabsDelegate old) {
    return old.child != child || old.height != height;
  }
}
