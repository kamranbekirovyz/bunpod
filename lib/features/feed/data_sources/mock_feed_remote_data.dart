import 'package:bunpod/bunpod.dart';

// Flip to see onboarding, then hot restart.
const bool _emptyFeed = false;

class MockFeedRemoteData implements FeedRemoteData {
  const MockFeedRemoteData();

  @override
  Future<List<Episode>> feed({int? channelId}) async {
    await Future<void>.delayed(AppValues.mockDelay);

    if (_emptyFeed) return const [];

    return [
      for (final Episode episode in mockEpisodes)
        if (channelId == null || episode.channelId == channelId) episode,
    ];
  }
}
