import 'dart:ui';

import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class OnboardingRemoteData {
  const OnboardingRemoteData();

  Dio get _dio => locator<Dio>();

  Future<List<TrendingPodcast>> trending() async {
    final Endpoint endpoint = RestfulEndpoints.trending(
      country: PlatformDispatcher.instance.locale.countryCode?.toLowerCase(),
    );

    final Response<Map<String, dynamic>> response = await _dio
        .request<Map<String, dynamic>>(
          endpoint.url,
          options: Options(
            method: endpoint.method,
          ),
        );

    final List<dynamic> items = response.data?['items'] ?? [];

    return [for (final dynamic item in items) TrendingPodcast.fromJson(item)];
  }

  Future<void> subscribeMany(List<int> appleIds) async {
    final Endpoint endpoint = RestfulEndpoints.subscribeMany(
      appleIds: appleIds,
    );

    await _dio.request<void>(
      endpoint.url,
      data: endpoint.body,
      options: Options(method: endpoint.method),
    );
  }
}
