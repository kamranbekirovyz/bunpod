import 'package:bunpod/bunpod.dart';

/// Always succeeds.
class MockSocialSignInService implements SocialSignInService {
  const MockSocialSignInService();

  @override
  Future<SocialSignInResult> signIn(AuthProvider provider) async {
    await Future<void>.delayed(AppValues.mockDelay);

    return SocialSignInResult(
      provider: provider,
      idToken: 'mock-id-token',
      uid: 'mock-uid',
      email: 'listener@bunpod.app',
      name: 'Mock Listener',
    );
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(AppValues.mockDelay);
  }
}
