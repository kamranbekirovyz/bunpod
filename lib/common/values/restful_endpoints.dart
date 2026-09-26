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
}
