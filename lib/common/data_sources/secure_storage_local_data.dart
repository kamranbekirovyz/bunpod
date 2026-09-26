import 'package:bunpod/bunpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _accessTokenKey = 'access_token';
const String _refreshTokenKey = 'refresh_token';

class SecureStorageLocalData {
  const SecureStorageLocalData();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: .first_unlock,
    ),
  );

  Future<String?> get accessToken {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> get refreshToken {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<void> cacheTokens(Tokens tokens) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: tokens.accessToken),
      _storage.write(key: _refreshTokenKey, value: tokens.refreshToken),
    ]);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}
