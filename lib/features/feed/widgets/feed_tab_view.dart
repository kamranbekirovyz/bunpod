import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// One episode list per tab, scrolling under the header.
class FeedTabView extends StatelessWidget {
  const FeedTabView({
    super.key,
    required this.header,
    required this.tabs,
    required this.onFeed,
  });

  final FeedHeaderController header;
  final List<Channel?> tabs;
  final ValueChanged<Feed?> onFeed;

  bool _snap(BuildContext context, ScrollEndNotification notification) {
    if (notification.depth != 1) return false;
    if (notification.metrics.axis != Axis.vertical) return false;

    header.snap(
      reduceMotion: MediaQuery.maybeDisableAnimationsOf(context) ?? false,
    );

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) => _snap(context, notification),
      child: BlocConsumer<FeedCubit, Map<int?, Feed>>(
        bloc: locator<FeedCubit>(),
        listener: (context, state) {
          onFeed(state[locator<FeedCubit>().channelId]);
        },
        builder: (context, state) {
          return TabBarView(
            controller: header.tabController,
            physics: const SpringPagePhysics(),
            children: [
              for (final (int i, Channel? channel) in tabs.indexed)
                FeedEpisodeList(
                  key: PageStorageKey('${channel?.id}'),
                  controller: header.scrollFor(i),
                  topPadding: header.headerMax,
                  feed: state[channel?.id],
                ),
            ],
          );
        },
      ),
    );
  }
}
