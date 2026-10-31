import 'dart:async';

import 'package:bunpod/bunpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

abstract final class Bootstrap {
  /// Always ends in [runApp]. If any launch step throws, the user gets a
  /// friendly error screen instead of a splash that never goes away.
  static Future<void> run(Widget Function() builder) async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await _init();
    } catch (error, stackTrace) {
      logarte.log('launch failed: $error');
      logarte.log('stack trace: $stackTrace');

      runApp(const LaunchFailureApp());

      LaunchFailureReporter.report(
        error: error,
        stackTrace: stackTrace,
      ).ignore();

      return;
    }

    runApp(builder());
  }

  static Future<void> _init() async {
    ErrorWidget.builder = (details) {
      return FriendlyErrorView(
        details: details,
      );
    };

    await precacheLogos();

    if (!AppConfig.useMocks) {
      await Firebase.initializeApp(
        options: FirebaseConfig.currentPlatform,
      );
    }

    UserOrient.configure(
      apiKey: AppConfig.userOrientApiKey,
      accentColor: MaterialThemes.light.colorScheme.primary,
      darkAccentColor: MaterialThemes.dark.colorScheme.primary,
    );

    await setupLocator();
    await clearStaleSecureStorage();
  }
}
