import 'package:bunpod/bunpod.dart';

// Flip to see onboarding, then hot restart.
const bool _emptyFeed = false;

class MockFeedRemoteData implements FeedRemoteData {
  const MockFeedRemoteData();

  @override
  Future<List<FeedEpisode>> feed() async {
    await Future<void>.delayed(AppValues.mockDelay);

    if (_emptyFeed) return const [];

    final List<String> channels = mockChannels.map((c) => c.name).toList();

    return [
      for (final (int index, Episode episode) in mockEpisodes.indexed)
        FeedEpisode(
          id: index,
          podcastId: channels.indexOf(episode.channel),
          title: episode.title,
          image: episode.image,
          publishedAt: DateTime.now().subtract(_ago[episode.bucket]!),
          duration: episode.total.inSeconds,
          position: episode.listened.inSeconds,
          completed: false,
        ),
    ];
  }
}

const Map<Bucket, Duration> _ago = {
  Bucket.today: Duration.zero,
  Bucket.yesterday: Duration(days: 1),
  Bucket.thisWeek: Duration(days: 3),
  Bucket.thisMonth: Duration(days: 10),
  Bucket.earlier: Duration(days: 60),
};
