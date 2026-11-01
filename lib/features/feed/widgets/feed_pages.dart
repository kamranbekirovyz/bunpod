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
    return ValueListenableBuilder<double?>(
      valueListenable: header.cardHeight,
      builder: (context, _, _) {
        return ExpressiveRefreshIndicator(
          onRefresh: locator<FeedCubit>().refresh,
          edgeOffset: header.headerMax,
          notificationPredicate: (notification) {
            return notification.depth == 1;
          },
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) => _snap(context, notification),
            child: StreamBuilder<int?>(
              stream: locator<FeedCubit>().channelId$,
              builder: (context, snapshot) {
                final int? channelId = snapshot.data;

                return BlocConsumer<FeedCubit, Feed?>(
                  bloc: locator<FeedCubit>(),
                  listener: (context, feed) => onFeed(feed),
                  builder: (context, feed) {
                    return TabBarView(
                      controller: header.tabController,
                      physics: const SpringPagePhysics(),
                      children: [
                        for (final (int i, Channel? channel) in tabs.indexed)
                          FeedEpisodeList(
                            key: PageStorageKey('${channel?.id}'),
                            controller: header.scrollFor(i),
                            topPadding: header.headerMax,
                            feed: channel?.id == channelId ? feed : null,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
