import 'package:bunpod/bunpod.dart';

/// How someone left before landing on [WelcomePage].
enum Farewell {
  none(
    title: 'Podcasts, meet expression.',
    subtitle: 'Pick a few shows and press play.',
    action: 'Start listening',
  ),
  logout(
    title: 'Paused, not stopped.',
    subtitle: 'Pick up right where you left off.',
    action: 'Sign back in',
  ),
  deletion(
    title: 'Clean slate.',
    subtitle: 'Everything is gone. The door stays open.',
    action: 'Start fresh',
  );

  const Farewell({
    required this.title,
    required this.subtitle,
    required this.action,
  });

  final String title;
  final String subtitle;
  final String action;
}
