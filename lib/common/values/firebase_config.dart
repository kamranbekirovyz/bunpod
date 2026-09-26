import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase options from dart-defines, so no native config files are needed.
/// Null when the keys are missing.
abstract final class FirebaseConfig {
  static const String _projectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );
  static const String _messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const String _storageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
  );

  static const String _androidApiKey = String.fromEnvironment(
    'FIREBASE_ANDROID_API_KEY',
  );
  static const String _androidAppId = String.fromEnvironment(
    'FIREBASE_ANDROID_APP_ID',
  );

  static const String _iosApiKey = String.fromEnvironment(
    'FIREBASE_IOS_API_KEY',
  );
  static const String _iosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID');
  static const String _iosBundleId = String.fromEnvironment(
    'FIREBASE_IOS_BUNDLE_ID',
  );

  static FirebaseOptions? get currentPlatform {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => _android,
      TargetPlatform.iOS => _ios,
      _ => null,
    };
  }

  static FirebaseOptions? get _android {
    if (!_shared || _androidApiKey.isEmpty || _androidAppId.isEmpty) {
      return null;
    }

    return FirebaseOptions(
      apiKey: _androidApiKey,
      appId: _androidAppId,
      messagingSenderId: _messagingSenderId,
      projectId: _projectId,
      storageBucket: _storageBucket,
    );
  }

  static FirebaseOptions? get _ios {
    if (!_shared || _iosApiKey.isEmpty || _iosAppId.isEmpty) {
      return null;
    }

    return FirebaseOptions(
      apiKey: _iosApiKey,
      appId: _iosAppId,
      messagingSenderId: _messagingSenderId,
      projectId: _projectId,
      storageBucket: _storageBucket,
      iosBundleId: _iosBundleId,
    );
  }

  static bool get _shared =>
      _projectId.isNotEmpty &&
      _messagingSenderId.isNotEmpty &&
      _storageBucket.isNotEmpty;
}
