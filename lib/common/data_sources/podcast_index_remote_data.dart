import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class PodcastIndexRemoteData {
  const PodcastIndexRemoteData();

  Future<Channel?> byFeedId(int id) {
    return _feed(PodcastIndexEndpoints.byFeedId(id));
  }

  Future<Channel?> byItunesId(int appleId) {
    return _feed(PodcastIndexEndpoints.byItunesId(appleId));
  }

  Future<Channel?> byFeedUrl(String url) async {
    try {
      return await _feed(PodcastIndexEndpoints.byFeedUrl(url));
    } on DioException catch (error) {
      // A miss is either `feed: []` or a 400, depending on the URL.
      if (error.response?.statusCode == 400) return null;
      rethrow;
    }
  }

  Future<List<Channel>> searchByTitle(String title, {required int max}) {
    return _feeds(PodcastIndexEndpoints.searchByTitle(title, max: max));
  }

  Future<List<Channel>> searchByTerm(String term, {required int max}) {
    return _feeds(PodcastIndexEndpoints.searchByTerm(term, max: max));
  }

  Future<Channel?> _feed(Endpoint endpoint) async {
    final Map<String, dynamic> body = await _get(endpoint);
    final Object? feed = body['feed'];

    // A miss comes back as `feed: []` instead of a 404.
    return feed is Map<String, dynamic> ? Channel.fromPodcastIndex(feed) : null;
  }

  Future<List<Channel>> _feeds(Endpoint endpoint) async {
    final Map<String, dynamic> body = await _get(endpoint);
    final List<dynamic> feeds = body['feeds'] ?? [];

    return [for (final dynamic feed in feeds) Channel.fromPodcastIndex(feed)];
  }

  Future<Map<String, dynamic>> _get(Endpoint endpoint) async {
    final Response<Map<String, dynamic>> response = await endpoint
        .send<Map<String, dynamic>>();

    return response.data ?? {};
  }
}
