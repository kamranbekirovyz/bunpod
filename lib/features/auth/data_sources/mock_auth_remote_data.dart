import 'package:bunpod/bunpod.dart';

class MockAuthRemoteData implements AuthRemoteData {
  const MockAuthRemoteData();

  @override
  Future<Tokens> socialSignIn({
    required AuthProvider provider,
    required String idToken,
    String? device,
  }) async {
    await Future<void>.delayed(AppValues.mockDelay);

    return const Tokens(
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
    );
  }

  @override
  Future<void> logout(String refreshToken) async {
    await Future<void>.delayed(AppValues.mockDelay);
  }
}
