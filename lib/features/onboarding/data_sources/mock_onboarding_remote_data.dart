import 'package:bunpod/bunpod.dart';

class MockOnboardingRemoteData implements OnboardingRemoteData {
  const MockOnboardingRemoteData();

  @override
  Future<List<TrendingPodcast>> trending() async {
    await Future<void>.delayed(AppValues.mockDelay);

    return [
      for (final (int index, MockChannel channel) in mockChannels.indexed)
        TrendingPodcast(
          appleId: index + 1,
          title: channel.name,
          author: channel.host,
          image: channel.image,
        ),
    ];
  }

  @override
  Future<void> subscribeMany(List<int> appleIds) async {
    await Future<void>.delayed(AppValues.mockDelay);
  }
}
