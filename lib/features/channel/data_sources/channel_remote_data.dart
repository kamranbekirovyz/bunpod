import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

class ChannelRemoteData {
  const ChannelRemoteData();

  Future<Channel> channel({required int id}) async {
    final Response<Map<String, dynamic>> response =
        await RestfulEndpoints.channel(id: id).send<Map<String, dynamic>>();

    return Channel.fromJson(response.data ?? {});
  }

  Future<Channel> channelByAppleId({required int appleId}) async {
    final Response<Map<String, dynamic>> response =
        await RestfulEndpoints.channelByAppleId(
          appleId: appleId,
        ).send<Map<String, dynamic>>();

    return Channel.fromJson(response.data ?? {});
  }

  Future<List<Episode>> episodes({required int id}) async {
    final Response<Map<String, dynamic>> response =
        await RestfulEndpoints.channelEpisodes(
          id: id,
        ).send<Map<String, dynamic>>();

    final List<dynamic> items = response.data?['items'] ?? [];

    return [for (final dynamic item in items) Episode.fromJson(item)];
  }

  Future<void> subscribe({required int id}) async {
    await RestfulEndpoints.subscribe(id: id).send<void>();
  }

  Future<void> unsubscribe({required int id}) async {
    await RestfulEndpoints.unsubscribe(id: id).send<void>();
  }
}
