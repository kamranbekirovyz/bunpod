import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

/// Trades a Firebase ID token for backend [Tokens].
class AuthRemoteData {
  const AuthRemoteData();

  Future<Tokens> socialSignIn({
    required AuthProvider provider,
    required String idToken,
    String? device,
  }) async {
    final Response<Map<String, dynamic>> response =
        await RestfulEndpoints.socialSignIn(
          provider: provider,
          idToken: idToken,
          device: device,
        ).send<Map<String, dynamic>>();

    return Tokens.fromJson(response.data!);
  }

  Future<void> logout(String refreshToken) async {
    await RestfulEndpoints.logout(refreshToken: refreshToken).send<void>();
  }
}
