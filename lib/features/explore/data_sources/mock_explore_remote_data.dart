import 'package:bunpod/bunpod.dart';

class MockExploreRemoteData implements ExploreRemoteData {
  const MockExploreRemoteData();

  @override
  Future<List<Category>> categories() async {
    await Future<void>.delayed(AppValues.mockDelay);

    return const [
      Category(id: 1303, name: 'Comedy'),
      Category(id: 1489, name: 'News'),
      Category(id: 1488, name: 'True Crime'),
      Category(id: 1321, name: 'Business'),
      Category(id: 1318, name: 'Technology'),
      Category(id: 1533, name: 'Science'),
      Category(id: 1304, name: 'Education'),
      Category(id: 1324, name: 'Society & Culture'),
    ];
  }

  @override
  Future<List<ChannelPreview>> trending({int? categoryId}) async {
    await Future<void>.delayed(AppValues.mockDelay);

    final List<ChannelPreview> all = _previews();

    return categoryId == null ? all : all.reversed.take(9).toList();
  }

  @override
  Future<List<ChannelPreview>> search(String query) async {
    await Future<void>.delayed(AppValues.mockDelay);

    final String q = query.toLowerCase();

    return [
      for (final ChannelPreview preview in _previews())
        if ('${preview.title} ${preview.author}'.toLowerCase().contains(q))
          preview,
    ];
  }

  List<ChannelPreview> _previews() {
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
}
