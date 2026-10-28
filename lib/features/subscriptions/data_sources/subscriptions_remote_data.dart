import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class SubscriptionsRemoteData {
  const SubscriptionsRemoteData();

  Dio get _dio => locator<Dio>();

  Future<List<Podcast>> subscriptions() async {
    final Endpoint endpoint = RestfulEndpoints.subscriptions();

    final Response<Map<String, dynamic>> response = await _dio
        .request<Map<String, dynamic>>(
          endpoint.url,
          options: Options(
            method: endpoint.method,
          ),
        );

    final List<dynamic> items = response.data?['items'] ?? [];

    return [for (final dynamic item in items) Podcast.fromJson(item)];
  }
}
