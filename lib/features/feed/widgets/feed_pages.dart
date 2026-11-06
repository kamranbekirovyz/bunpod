import 'package:bunpod/bunpod.dart';
import 'package:expressive_refresh_indicator/expressive_refresh_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// One episode list per tab, scrolling under the header.
class FeedPages extends StatelessWidget {
  const FeedPages({
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
    return ExpressiveRefreshIndicator(
      onRefresh: locator<FeedCubit>().refresh,
      edgeOffset: header.headerMax,
      notificationPredicate: (notification) {
        return notification.depth == 1;
      },
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) => _snap(context, notification),
        child: BlocConsumer<FeedCubit, FeedState>(
          bloc: locator<FeedCubit>(),
          listener: (context, state) {
            onFeed(state.feedOf(locator<FeedCubit>().channelId));
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
                    feed: state.feedOf(channel?.id),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
