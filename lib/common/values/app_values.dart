abstract final class AppValues {
  static String get title => 'BunPod';

  // Podcast Index asks clients to name themselves.
  static const String userAgent = 'BunPod/1.0';

  static const Duration feedRefreshTimeout = Duration(seconds: 15);

  static String get termsUrl => 'https://bunpod.app/terms';
  static String get privacyUrl => 'https://bunpod.app/privacy';

  static String get makerImageUrl =>
      'https://avatars.githubusercontent.com/u/59581562?v=4';
  static String get makerName => 'Kamran Bekirov';
  static String get makerXHandle => '@kamranbekirovyz';
  static String get makerXUrl => 'https://x.com/kamranbekirovyz';
  static String get makerPortfolioUrl => 'https://kamranbekirov.com';
  static String get makerEmail => 'me@kamranbekirov.com';
  static String get supportEmail => 'kamran@bunpod.app';
}
