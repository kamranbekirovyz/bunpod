import 'dart:ui';

import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class OnboardingRemoteData {
  const OnboardingRemoteData();

  Future<List<TrendingPodcast>> trending() async {
    final Response<Map<String, dynamic>> response =
        await RestfulEndpoints.trending(
          country: PlatformDispatcher.instance.locale.countryCode
              ?.toLowerCase(),
        ).send<Map<String, dynamic>>();

    final List<dynamic> items = response.data?['items'] ?? [];

    return [for (final dynamic item in items) TrendingPodcast.fromJson(item)];
  }

  Future<void> subscribeMany(List<int> appleIds) async {
    await RestfulEndpoints.subscribeMany(appleIds: appleIds).send<void>();
  }
}
