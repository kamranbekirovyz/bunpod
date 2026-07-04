import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';

/// Standard "not built yet" feedback for stubbed actions.
abstract final class ComingSoon {
  static void show(BuildContext context) {
    AppSnack.show(
      context,
      'Coming soon — stay tuned!',
      icon: Icons.rocket_launch_rounded,
    );
  }
}
