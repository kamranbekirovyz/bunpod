import 'package:expressive_snack/expressive_snack.dart';
import 'package:flutter/material.dart';

/// Standard "not built yet" feedback for stubbed actions.
abstract final class ComingSoon {
  static void show(BuildContext context) {
    showExpressiveSnack(
      context: context,
      message: 'Coming soon — stay tuned!',
      icon: Icons.rocket_launch_rounded,
    );
  }
}
