/// Injected via `--dart-define-from-file=local.json`. Empty means mocks.
abstract final class AppConfig {
  static const String baseUrl = String.fromEnvironment('BASE_URL');

  /// No backend configured, so every remote service is swapped for a mock.
  static bool get useMocks => baseUrl.isEmpty;

  /// Google Cloud web client id.
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  /// iOS only. Reversed form goes in `ios/Flutter/Secrets.xcconfig`.
  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
  );
}
