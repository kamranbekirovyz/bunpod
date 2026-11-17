import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class RssBody {
  const RssBody({
    required this.xml,
    this.etag,
    this.lastModified,
  });

  final String xml;
  final String? etag;
  final String? lastModified;
}

class RssRemoteData {
  const RssRemoteData();

  // Null when the feed hasn't changed since the last fetch.
  Future<RssBody?> fetch(
    String url, {
    String? etag,
    String? lastModified,
  }) async {
    final Response<String> response =
        await RssEndpoints.feed(
          url,
          etag: etag,
          lastModified: lastModified,
        ).send<String>(
          responseType: .plain,
          validateStatus: (int? status) {
            return status == 200 || status == 304;
          },
        );

    if (response.statusCode == 304) return null;

    return RssBody(
      xml: response.data ?? '',
      etag: response.headers.value('etag'),
      lastModified: response.headers.value('last-modified'),
    );
  }
}
