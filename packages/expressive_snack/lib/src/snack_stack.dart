import 'package:flutter/material.dart';

import 'snack.dart';
import 'snack_overlay.dart';
import 'snack_view.dart';

/// The single overlay entry: every live pill bottom-anchored in one spot,
/// each rendering itself at its dealt depth (0 = front) like a card stack.
class SnackStack extends StatelessWidget {
  const SnackStack({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          // The keyboard reports through viewInsets, which SafeArea does
          // not cover. Without this a snack shown while typing hides
          // behind the keyboard.
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: ValueListenableBuilder(
            valueListenable: SnackOverlay.snacks,
            builder: (context, snacks, _) {
              // Deal depths newest-first; a dismissing pill holds its spot
              // without claiming one, so the pile behind it moves up.
              int next = 0;
              final Map<Snack, int> depths = {
                for (final Snack snack in snacks.reversed)
                  snack: (snack.key.currentState?.isDismissing ?? false)
                      ? next
                      : next++,
              };

              return Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  for (final Snack snack in snacks)
                    SnackView(
                      key: snack.key,
                      snack: snack,
                      depth: depths[snack]!,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
