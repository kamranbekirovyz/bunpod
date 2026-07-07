import 'package:flutter/material.dart';

import 'snack_view.dart';

/// One shown snack and the key that reaches its live view.
class Snack {
  Snack({required this.message, required this.icon, required this.duration});

  final GlobalKey<SnackViewState> key = GlobalKey();
  final String message;
  final IconData? icon;
  final Duration duration;
}
