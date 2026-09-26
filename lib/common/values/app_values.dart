abstract final class AppValues {
  static String get title => 'BunPod';

  /// What every mock waits before answering, so the loading states are visible.
  static const Duration mockDelay = Duration(milliseconds: 250);

  /// One page covering both the terms and the privacy policy, so the sign-in
  /// small print stays a single sentence with a single link in it.
  static String get legalUrl => 'https://bunpod.app/legal';

  static String get makerImageUrl =>
      'https://avatars.githubusercontent.com/u/59581562?v=4';
  static String get makerName => 'Kamran Bekirov';
  static String get makerXHandle => '@kamranbekirovyz';
  static String get makerXUrl => 'https://x.com/kamranbekirovyz';
  static String get makerPortfolioUrl => 'https://kamranbekirov.com';
  static String get makerEmail => 'me@kamranbekirov.com';
}
