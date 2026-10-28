import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class OnboardingRemoteData {
  const OnboardingRemoteData();

  Future<List<ChannelPreview>> trending() async {
    final Response<Map<String, dynamic>> response =
        await RestfulEndpoints.trending().send<Map<String, dynamic>>();

    final List<dynamic> items = response.data?['items'] ?? [];

    return [for (final dynamic item in items) ChannelPreview.fromJson(item)];
  }

  Future<void> subscribeMany(List<int> appleIds) async {
    await RestfulEndpoints.subscribeMany(appleIds: appleIds).send<void>();
  }
}
