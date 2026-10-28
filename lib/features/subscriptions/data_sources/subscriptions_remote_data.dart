import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class SubscriptionsRemoteData {
  const SubscriptionsRemoteData();

  Future<List<Podcast>> subscriptions() async {
    final Response<Map<String, dynamic>> response =
        await RestfulEndpoints.subscriptions().send<Map<String, dynamic>>();

    final List<dynamic> items = response.data?['items'] ?? [];

    return [for (final dynamic item in items) Podcast.fromJson(item)];
  }
}
