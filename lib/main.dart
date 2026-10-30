import 'package:bunpod/bunpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await precacheLogos();

  if (!AppConfig.useMocks) {
    await Firebase.initializeApp(
      options: FirebaseConfig.currentPlatform,
    );
  }

  ErrorWidget.builder = (details) {
    return FriendlyErrorView(
      details: details,
    );
  };

  UserOrient.configure(
    apiKey: AppConfig.userOrientApiKey,
    accentColor: MaterialThemes.light.colorScheme.primary,
    darkAccentColor: MaterialThemes.dark.colorScheme.primary,
  );

  await setupLocator();

  final bool signedIn =
      await locator<SecureStorageLocalData>().accessToken != null;

  runApp(App(signedIn: signedIn));
}
