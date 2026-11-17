abstract final class AppConfig {
  static const String podcastIndexKey = String.fromEnvironment(
    'PODCAST_INDEX_KEY',
  );

  static const String podcastIndexSecret = String.fromEnvironment(
    'PODCAST_INDEX_SECRET',
  );

  static const String userOrientApiKey = String.fromEnvironment(
    'USERORIENT_API_KEY',
  );

  /// Bot that receives launch failure alerts.
  static const String telegramBotToken = String.fromEnvironment(
    'TELEGRAM_BOT_TOKEN',
  );

  static const String telegramChatId = String.fromEnvironment(
    'TELEGRAM_CHAT_ID',
  );
}
