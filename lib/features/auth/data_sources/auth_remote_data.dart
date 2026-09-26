import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

/// Trades a Firebase ID token for backend [Tokens].
class AuthRemoteData {
  const AuthRemoteData();

  Dio get _dio => locator<Dio>();

  Future<Tokens> socialSignIn({
    required AuthProvider provider,
    required String idToken,
    String? device,
  }) async {
    final Endpoint endpoint = RestfulEndpoints.socialSignIn(
      provider: provider,
      idToken: idToken,
      device: device,
    );

    final Response<Map<String, dynamic>> response = await _dio
        .request<Map<String, dynamic>>(
          endpoint.url,
          data: endpoint.body,
          options: Options(method: endpoint.method),
        );

    return Tokens.fromJson(response.data!);
  }

  Future<void> logout(String refreshToken) async {
    final Endpoint endpoint = RestfulEndpoints.logout(
      refreshToken: refreshToken,
    );

    await _dio.request<void>(
      endpoint.url,
      data: endpoint.body,
      options: Options(method: endpoint.method),
    );
  }
}
