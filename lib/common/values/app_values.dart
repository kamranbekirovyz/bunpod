abstract final class AppValues {
  static String get title => 'BunPod';

  /// What every mock waits before answering, so the loading states are visible.
  static const Duration mockDelay = Duration(milliseconds: 250);

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
