import 'package:bunpod/bunpod.dart';

class ChannelEpisodesCubit extends PagedCubit<Episode> {
  late Channel _channel;

  Future<void> load({required Channel channel}) {
    _channel = channel;

    return refresh();
  }

  @override
  Future<List<Episode>> fetch({
    required int offset,
    required int limit,
  }) async {
    final String? feedUrl = _channel.feedUrl;
    if (feedUrl == null) return const [];

    if (offset == 0) await locator<FeedSync>().sync(_channel);

    return locator<EpisodesLocalData>().episodes(
      feedUrls: [feedUrl],
      offset: offset,
      limit: limit,
    );
  }
}
