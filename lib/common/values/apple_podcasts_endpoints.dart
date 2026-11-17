import 'package:bunpod/bunpod.dart';

abstract final class ApplePodcastsEndpoints {
  // The legacy chart, since the newer one times out and can't filter by genre.
  static Endpoint topShows({
    required String country,
    required int limit,
    int? genre,
  }) {
    final String filter = genre == null ? '' : '/genre=$genre';

    return Endpoint(
      url:
          'https://itunes.apple.com/$country/rss/toppodcasts/limit=$limit$filter/json',
    );
  }

  static Endpoint search(
    String term, {
    required String country,
    required int limit,
  }) {
    return Endpoint(
      url: 'https://itunes.apple.com/search',
      query: {
        'media': 'podcast',
        'entity': 'podcast',
        'term': term,
        'country': country,
        'limit': limit,
      },
    );
  }
}
