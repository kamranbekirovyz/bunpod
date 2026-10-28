import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class FeedRemoteData {
  const FeedRemoteData();

  Future<List<Episode>> feed({
    int? channelId,
  }) async {
    final Response<Map<String, dynamic>> response = await RestfulEndpoints.feed(
      channelId: channelId,
    ).send<Map<String, dynamic>>();

    final List<dynamic> items = response.data?['items'] ?? [];

    return [for (final dynamic item in items) Episode.fromJson(item)];
  }
}
