import 'package:bunpod/bunpod.dart';

class RestfulEndpoints {
  const RestfulEndpoints._();

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

  static Endpoint feed({int? limit}) {
    return Endpoint.get(
      url: '${AppConfig.baseUrl}/feed${limit == null ? '' : '?limit=$limit'}',
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
    String? country,
    int? limit,
  }) {
    final Map<String, String> query = {
      'country': ?country,
      'limit': ?limit?.toString(),
    };

    return Endpoint.get(
      url: Uri.parse('${AppConfig.baseUrl}/podcasts/trending')
          .replace(queryParameters: query.isEmpty ? null : query)
          .toString(),
    );
  }
}
