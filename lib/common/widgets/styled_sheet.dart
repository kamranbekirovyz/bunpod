import 'package:bunpod/bunpod.dart';
import 'package:expressive_sheet/expressive_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_shapes/material_shapes.dart';

/// A floating confirmation card that slides up from the bottom edge — the
/// app's replacement for center dialogs. Fully rounded (28dp) and inset from
/// the screen edges, with a shaped hero icon and stacked full-width actions.
/// Destructive confirmations swap to error colors and a burst-shaped icon.
///
/// Resolves to `true` only when the confirm action is tapped; dismissing by
/// scrim tap, drag, or back gesture resolves to `false`.
class StyledSheet extends StatelessWidget {
  const StyledSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String confirmLabel;
  final bool destructive;

  static Future<bool> show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    required String confirmLabel,
    bool destructive = false,
  }) async {
    final bool? confirmed = await showExpressiveSheet<bool>(
      context: context,
      builder: (context) {
        return StyledSheet(
          icon: icon,
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          destructive: destructive,
        );
      },
    );

    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    final Color heroBackground = destructive
        ? cs.errorContainer
        : cs.secondaryContainer;
    final Color heroForeground = destructive
        ? cs.onErrorContainer
        : cs.onSecondaryContainer;

    return Padding(
      padding: .all(16),
      // Dialog spec: container width is capped at 560dp on larger screens.
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
        ),
        child: Material(
          color: cs.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            // M3 concentric nesting: outer radius = inner radius + padding.
            // The stadium buttons inside are 28 (56dp tall) behind 24 padding.
            borderRadius: .circular(52),
          ),
          clipBehavior: .antiAlias,
          child: Padding(
            padding: const .all(24),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: ShapeDecoration(
                      color: heroBackground,
                      shape: MaterialShapeBorder(
                        shape: destructive
                            ? MaterialShapes.sunny
                            : MaterialShapes.cookie7Sided,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: heroForeground,
                    ),
                  ),
                ),
                16.gap,
                Text(
                  title,
                  textAlign: .center,
                  style: GoogleFonts.unbounded(
                    textStyle: tt.titleLarge,
                    fontWeight: .w700,
                    letterSpacing: -0.5,
                  ),
                ),
                16.gap,
                Text(
                  message,
                  textAlign: .center,
                  style: tt.bodyMedium?.copyWith(
                    height: 1.4,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                24.gap,
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      textStyle: tt.titleMedium,
                      backgroundColor: destructive ? cs.error : null,
                      foregroundColor: destructive ? cs.onError : null,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      confirmLabel,
                    ),
                  ),
                ),
                8.gap,
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    style: FilledButton.styleFrom(
                      textStyle: tt.titleMedium,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text(
                      'Cancel',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
