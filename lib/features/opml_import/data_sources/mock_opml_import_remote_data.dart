import 'package:bunpod/bunpod.dart';

class MockOpmlImportRemoteData implements OpmlImportRemoteData {
  const MockOpmlImportRemoteData();

  @override
  Future<OpmlImport> import({
    required List<int> bytes,
    required String fileName,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 4));

    final List<Channel> channels = [
      for (final (int index, MockChannel channel) in mockChannels.indexed)
        Channel(
          id: index,
          appleId: index + 1,
          title: channel.name,
          author: channel.host,
          image: channel.image,
        ),
    ];

    return OpmlImport(
      subscribed: channels.skip(3).toList(),
      suggestions: [
        OpmlSuggestion(
          feed: OpmlFeed(
            title: '${channels[0].title} (old feed)',
            url: 'https://feeds.example.com/old',
          ),
          options: channels.take(3).toList(),
        ),
        OpmlSuggestion(
          feed: OpmlFeed(
            title: channels[1].title?.toLowerCase(),
            url: 'https://rss.example.org/show',
          ),
          options: channels.skip(1).take(2).toList(),
        ),
      ],
      unavailable: const [
        OpmlFeed(
          title: 'Members Only Bonus Feed',
          url: 'https://www.patreon.com/rss/show?auth=secret',
        ),
        OpmlFeed(
          title: 'A Show That Ended in 2019',
          url: 'https://feeds.retired.fm/show',
        ),
      ],
    );
  }
}
