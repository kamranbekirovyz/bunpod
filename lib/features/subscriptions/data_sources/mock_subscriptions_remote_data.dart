import 'package:bunpod/bunpod.dart';

class MockSubscriptionsRemoteData implements SubscriptionsRemoteData {
  const MockSubscriptionsRemoteData();

  @override
  Future<List<Podcast>> subscriptions() async {
    await Future<void>.delayed(AppValues.mockDelay);

    return [
      for (final (int index, Channel channel) in mockChannels.indexed)
        Podcast(
          id: index,
          title: channel.name,
          author: channel.host,
          description: channel.description,
          image: channel.image,
        ),
    ];
  }
}
