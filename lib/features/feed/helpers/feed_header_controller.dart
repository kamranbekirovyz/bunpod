import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

/// Drives the feed header from the visible list's scroll. The first [range]
/// shrinks the card into a pill, the next [pillArea] pushes the pill out of
/// the top, and past [total] it docks at the bottom.
class FeedHeaderController {
  FeedHeaderController({required this.tabController});

  final TabController tabController;

  final ValueNotifier<double> shrink = ValueNotifier<double>(0);

  final Map<int, ScrollController> _scrolls = {};

  static const double cardHeight = FeedNowPlayingCard.expandedHeight;
  static const double tabsHeight = 64;
  static const double pillHeight = 64;
  static const EdgeInsets cardPadding = EdgeInsets.fromLTRB(16, 24, 16, 16);

  double get headerMax => cardHeight + cardPadding.vertical + tabsHeight;

  /// Scroll spent shrinking the card into the pill.
  double get range => cardHeight - pillHeight;

  /// Scroll spent pushing the pill out of the top.
  double get pillArea => pillHeight + cardPadding.vertical;

  double get total => range + pillArea;

  double get collapse => (shrink.value / range).clamp(0.0, 1.0);

  double get pushed => ((shrink.value - range) / pillArea).clamp(0.0, 1.0);

  bool get docked => shrink.value >= total;

  ScrollController scrollFor(int index) {
    return _scrolls.putIfAbsent(index, () {
      final ScrollController controller = ScrollController();

      controller.addListener(() {
        if (index != tabController.index) return;

        shrink.value = controller.offset.clamp(0.0, total);
      });

      return controller;
    });
  }

  /// Matches a newly selected list to the current header.
  void sync() {
    final ScrollController controller = scrollFor(tabController.index);
    if (!controller.hasClients) return;

    if (controller.offset < total) {
      controller.jumpTo(shrink.value);
    } else {
      shrink.value = total;
    }
  }

  /// Settles a half shrunk card or a half pushed pill at the nearer end.
  void snap({required bool reduceMotion}) {
    final ScrollController controller = scrollFor(tabController.index);
    if (!controller.hasClients) return;

    final double offset = controller.offset;
    if (offset <= 0 || offset >= total || offset == range) return;

    final double target = offset < range
        ? (offset < range / 2 ? 0 : range)
        : (offset < (range + total) / 2 ? range : total);

    Future<void>.microtask(() {
      if (!controller.hasClients) return;

      if (reduceMotion) {
        controller.jumpTo(target);
        return;
      }

      controller.animateTo(
        target,
        duration: const Duration(milliseconds: 350),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    });
  }

  void dispose() {
    for (final ScrollController controller in _scrolls.values) {
      controller.dispose();
    }
    shrink.dispose();
  }
}
