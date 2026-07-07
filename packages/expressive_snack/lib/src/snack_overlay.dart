import 'package:flutter/material.dart';

import 'snack.dart';
import 'snack_stack.dart';

/// Owns the live list of snacks and the single [OverlayEntry] rendering
/// them. It mounts with the first snack and unmounts when the last one
/// leaves.
abstract final class SnackOverlay {
  static const int maxStack = 3;

  static final ValueNotifier<List<Snack>> snacks = ValueNotifier(const []);
  static OverlayEntry? _entry;

  /// Snacks that are not animating out yet. Only these count for stacking
  /// and duplicate checks.
  static List<Snack> get alive => snacks.value
      .where((s) => !(s.key.currentState?.isDismissing ?? false))
      .toList();

  static void add(Snack snack, OverlayState overlay) {
    snacks.value = [...snacks.value, snack];
    if (_entry == null) {
      _entry = OverlayEntry(builder: (context) => const SnackStack());
      overlay.insert(_entry!);
    }
  }

  /// Moves [snack] to the newest spot so the stack deals it to the front.
  /// The depth springs animate the reorder, so the pill slides forward
  /// while the others settle back.
  static void promote(Snack snack) {
    if (snacks.value.last == snack) return;
    snacks.value = [
      for (final Snack s in snacks.value)
        if (s != snack) s,
      snack,
    ];
  }

  static void remove(Snack snack) {
    snacks.value = [...snacks.value]..remove(snack);
    if (snacks.value.isEmpty) {
      _entry?.remove();
      _entry = null;
    }
  }

  /// Re-emits the list so the stack deals depths again. Called when a pill
  /// starts dismissing, so the ones behind it spring forward right away
  /// instead of waiting for its exit to finish.
  static void refresh() {
    snacks.value = List.of(snacks.value);
  }
}
