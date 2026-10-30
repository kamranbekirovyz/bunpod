import 'package:bunpod/bunpod.dart';

class MockProfileRemoteData implements ProfileRemoteData {
  const MockProfileRemoteData();

  @override
  Future<User> me() async {
    await Future<void>.delayed(AppValues.mockDelay);

    return User(
      id: 'mock-user',
      provider: 'google',
      email: 'mock@bunpod.app',
      name: 'Mock User',
      createdAt: DateTime(2026),
    );
  }

  @override
  Future<void> deleteMe() async {
    await Future<void>.delayed(AppValues.mockDelay);
  }
}
