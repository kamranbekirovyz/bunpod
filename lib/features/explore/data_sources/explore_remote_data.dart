import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class ExploreRemoteData {
  const ExploreRemoteData();

  Future<List<Category>> categories() async {
    final Response<Map<String, dynamic>> response =
        await RestfulEndpoints.categories().send<Map<String, dynamic>>();

    final List<dynamic> items = response.data?['items'] ?? [];

    return [for (final dynamic item in items) Category.fromJson(item)];
  }

  Future<List<ChannelPreview>> trending({int? categoryId}) async {
    final Response<Map<String, dynamic>> response =
        await RestfulEndpoints.trending(
          categoryId: categoryId,
        ).send<Map<String, dynamic>>();

    final List<dynamic> items = response.data?['items'] ?? [];

    return [for (final dynamic item in items) ChannelPreview.fromJson(item)];
  }

  Future<List<ChannelPreview>> search(String query) async {
    final Response<Map<String, dynamic>> response =
        await RestfulEndpoints.search(
          query: query,
        ).send<Map<String, dynamic>>();

    final List<dynamic> items = response.data?['items'] ?? [];

    return [for (final dynamic item in items) ChannelPreview.fromJson(item)];
  }
}
