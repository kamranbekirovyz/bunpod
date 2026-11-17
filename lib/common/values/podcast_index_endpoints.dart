import 'dart:convert';

import 'package:bunpod/bunpod.dart';
import 'package:crypto/crypto.dart';

abstract final class PodcastIndexEndpoints {
  static const String _baseUrl = 'https://api.podcastindex.org/api/1.0';

  static Endpoint byFeedId(int id) {
    return _endpoint('/podcasts/byfeedid', {'id': id});
  }

  static Endpoint byItunesId(int appleId) {
    return _endpoint('/podcasts/byitunesid', {'id': appleId});
  }

  static Endpoint byFeedUrl(String url) {
    return _endpoint('/podcasts/byfeedurl', {'url': url});
  }

  static Endpoint searchByTitle(String title, {required int max}) {
    return _endpoint('/search/bytitle', {'q': title, 'max': max});
  }

  static Endpoint searchByTerm(String term, {required int max}) {
    return _endpoint('/search/byterm', {'q': term, 'max': max});
  }

  static Endpoint _endpoint(String path, Map<String, dynamic> query) {
    return Endpoint(
      url: '$_baseUrl$path',
      query: query,
      headers: _authHeaders(),
    );
  }

  // sha1(key + secret + unix seconds), signed per request.
  static Map<String, String> _authHeaders() {
    final String date = '${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
    final String signature = sha1
        .convert(
          utf8.encode(
            AppConfig.podcastIndexKey + AppConfig.podcastIndexSecret + date,
          ),
        )
        .toString();

    return {
      'X-Auth-Key': AppConfig.podcastIndexKey,
      'X-Auth-Date': date,
      'Authorization': signature,
    };
  }
}
