import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

/// The now playing card above the channel tabs. The card shrinks into a
/// pill, then rides up and out with the list.
class FeedHeader extends StatelessWidget {
  const FeedHeader({
    super.key,
    required this.header,
    required this.tabs,
    required this.channels,
    required this.suggested,
  });

  final FeedHeaderController header;
  final List<Channel?> tabs;
  final List<Channel> channels;
  final Episode? suggested;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: .min,
        children: [
          ValueListenableBuilder<double>(
            valueListenable: header.shrink,
            builder: (context, _, _) {
              return ClipRect(
                child: Align(
                  alignment: .bottomCenter,
                  heightFactor: 1 - header.pushed,
                  child: Padding(
                    padding: FeedHeaderController.cardPadding,
                    child: FeedNowPlaying(
                      suggested: suggested,
                      collapse: header.collapse,
                      onCardHeight: (height) {
                        header.cardHeight.value = height;
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: FeedHeaderController.tabsHeight,
            child: Center(
              child: _Tabs(
                tabController: header.tabController,
                tabs: tabs,
                channels: channels,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.tabController,
    required this.tabs,
    required this.channels,
  });

  final TabController tabController;
  final List<Channel?> tabs;
  final List<Channel> channels;

  void _select(BuildContext context, Channel? channel) {
    final Channel? current = tabs[tabController.index];

    // A second tap on the selected show opens its page.
    if (channel != null && channel == current) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) {
            return ChannelPage(
              id: channel.id,
              preview: ChannelPreview.fromChannel(channel),
            );
          },
        ),
      );
      return;
    }

    tabController.animateTo(tabs.indexOf(channel));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tabController.animation!,
      builder: (context, _) {
        final int highlighted = tabController.animation!.value.round();

        return FeedChannelTabs(
          channels: channels,
          selected: tabs[highlighted],
          onSelected: (channel) => _select(context, channel),
        );
      },
    );
  }
}
