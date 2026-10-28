import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class FeedRemoteData {
  const FeedRemoteData();

  Dio get _dio => locator<Dio>();

  Future<List<Episode>> feed({
    int? podcastId,
  }) async {
    final Endpoint endpoint = RestfulEndpoints.feed(
      podcastId: podcastId,
    );

    final Response<Map<String, dynamic>> response = await _dio
        .request<Map<String, dynamic>>(
          endpoint.url,
          options: Options(
            method: endpoint.method,
          ),
        );

    final List<dynamic> items = response.data?['items'] ?? [];

    return [for (final dynamic item in items) Episode.fromJson(item)];
  }
}
