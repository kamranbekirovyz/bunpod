import 'package:bunpod/bunpod.dart';

class FeedState {
  const FeedState({this.feeds = const {}});

  final Map<int?, Feed> feeds;

  Feed? feedOf(int? channelId) => feeds[channelId];

  FeedState withFeed(int? channelId, Feed feed) {
    return FeedState(
      feeds: {
        ...feeds,
        channelId: feed,
      },
    );
  }
}
