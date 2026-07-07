import 'package:flutter/material.dart';

import 'snack.dart';
import 'snack_overlay.dart';
import 'snack_view.dart';

/// Shows an expressive snack: a floating pill that springs up from the
/// bottom edge (expressive spatial in, standard fast out). When [icon] is
/// given, an arch shaped chip sits on the pill's rounded left end.
///
/// Repeated calls stack like cards. The newest pill lands in front and
/// older ones move back, peeking out above it, up to three deep. Past that
/// the oldest one leaves. If [message] and [icon] match a pill already on
/// screen, no new pill is added. That pill shakes and its countdown
/// restarts. Tap or flick a pill to dismiss it early. Each one dismisses
/// itself after its [duration].
///
/// Colors and text styles come from the ambient [Theme], following
/// [SnackBar]: an inverse surface container with body medium text.
void showExpressiveSnack({
  required BuildContext context,
  required String message,
  IconData? icon,
  // Spec: snackbars stay visible 4-10 seconds.
  Duration duration = const Duration(seconds: 4),
}) {
  final OverlayState overlay = Overlay.of(context, rootOverlay: true);
  final List<Snack> alive = SnackOverlay.alive;

  // A duplicate does not add a pill. The one already saying it comes to
  // the front and shakes. The forward slide and the sideways wobble run
  // on separate axes, so together they read as one smooth pull-and-shake.
  for (final Snack snack in alive) {
    if (snack.message == message && snack.icon == icon) {
      SnackOverlay.promote(snack);
      snack.key.currentState?.shake();
      return;
    }
  }

  // A full pile makes room: the oldest pill starts leaving now and stops
  // counting, so the newcomer never waits.
  if (alive.length >= SnackOverlay.maxStack) {
    final SnackViewState? oldest = alive.first.key.currentState;
    if (oldest != null) {
      oldest.dismiss();
    } else {
      SnackOverlay.remove(alive.first);
    }
  }

  SnackOverlay.add(
    Snack(message: message, icon: icon, duration: duration),
    overlay,
  );
}
