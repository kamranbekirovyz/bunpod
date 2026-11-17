import 'package:bunpod/bunpod.dart';

abstract final class RssEndpoints {
  static Endpoint feed(
    String url, {
    String? etag,
    String? lastModified,
  }) {
    return Endpoint(
      url: url,
      headers: {
        'If-None-Match': ?etag,
        'If-Modified-Since': ?lastModified,
      },
    );
  }
}
