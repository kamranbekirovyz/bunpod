import 'package:bunpod/bunpod.dart';

class MockOnboardingRemoteData implements OnboardingRemoteData {
  const MockOnboardingRemoteData();

  @override
  Future<List<ChannelPreview>> trending() async {
    await Future<void>.delayed(AppValues.mockDelay);

    return [
      for (final (int index, MockChannel channel) in mockChannels.indexed)
        ChannelPreview(
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
