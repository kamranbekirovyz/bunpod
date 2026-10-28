import 'package:bunpod/bunpod.dart';

class MockSubscriptionsRemoteData implements SubscriptionsRemoteData {
  const MockSubscriptionsRemoteData();

  @override
  Future<List<Channel>> subscriptions() async {
    await Future<void>.delayed(AppValues.mockDelay);

    return [
      for (final (int index, MockChannel channel) in mockChannels.indexed)
        Channel(
          id: index,
          title: channel.name,
          author: channel.host,
          description: channel.description,
          image: channel.image,
        ),
    ];
  }
}
