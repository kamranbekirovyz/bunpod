import 'package:bunpod/bunpod.dart';

class MockChannelRemoteData implements ChannelRemoteData {
  const MockChannelRemoteData();

  @override
  Future<Channel> channel({required int id}) async {
    await Future<void>.delayed(AppValues.mockDelay);

    final MockChannel mock = mockChannels[id % mockChannels.length];

    return Channel(
      id: id,
      title: mock.name,
      author: mock.host,
      description: mock.description,
      image: mock.image,
      subscribed: true,
    );
  }

  @override
  Future<Channel> channelByAppleId({required int appleId}) {
    return channel(id: appleId - 1);
  }

  @override
  Future<List<Episode>> episodes({required int id}) async {
    await Future<void>.delayed(AppValues.mockDelay);

    return [
      for (final Episode episode in mockEpisodes)
        if (episode.channelId == id) episode,
    ];
  }

  @override
  Future<void> subscribe({required int id}) async {
    await Future<void>.delayed(AppValues.mockDelay);
  }

  @override
  Future<void> unsubscribe({required int id}) async {
    await Future<void>.delayed(AppValues.mockDelay);
  }
}
