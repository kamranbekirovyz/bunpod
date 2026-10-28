import 'dart:ui';

import 'package:bunpod/bunpod.dart';

class RestfulEndpoints {
  const RestfulEndpoints._();

  static String? get _country =>
      PlatformDispatcher.instance.locale.countryCode?.toLowerCase();

  static Endpoint socialSignIn({
    required AuthProvider provider,
    required String idToken,
    String? device,
  }) {
    return Endpoint.post(
      url: '${AppConfig.baseUrl}/auth/social',
      body: {
        'provider': provider.name,
        'id_token': idToken,
        'device': ?device,
      },
    );
  }

  static Endpoint logout({
    required String refreshToken,
  }) {
    return Endpoint.post(
      url: '${AppConfig.baseUrl}/auth/logout',
      body: {
        'refresh_token': refreshToken,
      },
    );
  }

  static Endpoint feed({int? channelId, int? limit}) {
    return Endpoint.get(
      url: '${AppConfig.baseUrl}/feed',
      query: {
        'podcast_id': ?channelId,
        'limit': ?limit,
      },
    );
  }

  static Endpoint subscriptions() {
    return Endpoint.get(
      url: '${AppConfig.baseUrl}/subscriptions',
    );
  }

  static Endpoint subscribeMany({
    required List<int> appleIds,
  }) {
    return Endpoint.post(
      url: '${AppConfig.baseUrl}/subscriptions',
      body: {
        'apple_ids': appleIds,
      },
    );
  }

  static Endpoint trending({
    int? categoryId,
    int? limit,
  }) {
    return Endpoint.get(
      url: '${AppConfig.baseUrl}/podcasts/trending',
      query: {
        'country': ?_country,
        'category': ?categoryId,
        'limit': ?limit,
      },
    );
  }

  static Endpoint search({
    required String query,
    int? limit,
  }) {
    return Endpoint.get(
      url: '${AppConfig.baseUrl}/podcasts/search',
      query: {
        'q': query,
        'country': ?_country,
        'limit': ?limit,
      },
    );
  }

  static Endpoint categories() {
    return Endpoint.get(
      url: '${AppConfig.baseUrl}/podcasts/categories',
    );
  }

  static Endpoint channel({required int id}) {
    return Endpoint.get(
      url: '${AppConfig.baseUrl}/podcasts/$id',
    );
  }

  static Endpoint channelByAppleId({required int appleId}) {
    return Endpoint.get(
      url: '${AppConfig.baseUrl}/podcasts/apple/$appleId',
    );
  }

  static Endpoint channelEpisodes({required int id, int? limit}) {
    return Endpoint.get(
      url: '${AppConfig.baseUrl}/podcasts/$id/episodes',
      query: {
        'limit': ?limit,
      },
    );
  }

  static Endpoint subscribe({required int id}) {
    return Endpoint.put(
      url: '${AppConfig.baseUrl}/subscriptions/$id',
    );
  }

  static Endpoint unsubscribe({required int id}) {
    return Endpoint.delete(
      url: '${AppConfig.baseUrl}/subscriptions/$id',
    );
  }
}
