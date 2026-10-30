import 'package:bunpod/bunpod.dart';

/// iOS keeps Keychain items after the app is deleted, so a reinstall would
/// come back signed in with old tokens. Preferences do get deleted, so a
/// missing flag means a fresh install and the Keychain is wiped once.
Future<void> clearStaleSecureStorage() async {
  final PreferencesLocalData preferences = locator<PreferencesLocalData>();

  if (preferences.secureStorageCleared) return;

  await locator<SecureStorageLocalData>().clearAll();
  await preferences.cacheSecureStorageCleared();
}
