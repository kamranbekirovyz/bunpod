import 'package:bunpod/bunpod.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

Future<void> signOut() async {
  await locator<SecureStorageLocalData>().clearTokens();
  await locator<PreferencesLocalData>().clear();
  await locator<PlayerHandler>().stop();
  await UserOrient.logout();
}
