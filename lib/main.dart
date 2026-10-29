import 'package:bunpod/bunpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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

  await setupLocator();

  final bool signedIn =
      await locator<SecureStorageLocalData>().accessToken != null;

  runApp(App(signedIn: signedIn));
}
