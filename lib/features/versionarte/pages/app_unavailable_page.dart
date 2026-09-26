import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

/// Shown when the manifest switches the app off — maintenance, an outage, a
/// region being pulled.
///
/// Same layout as [ForceUpdatePage] and the same parts: a bloom off the bottom
/// corner, a chip with a leading glyph, a headline, one action. Every one of
/// them is turned down. The bloom is neutral instead of tinted and rides the
/// stiffest, slowest spring of the two; the action is outlined instead of
/// filled. Nothing here is saturated because nothing here is urgent — the app
/// should look asleep, not broken.
class AppUnavailablePage extends StatelessWidget {
  const AppUnavailablePage({
    super.key,
    required this.message,
    required this.checking,
    required this.onRetry,
  });

  /// Copy from the manifest, so the reason can be changed server-side without
  /// shipping a build.
  final String? message;

  final bool checking;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return VersionarteBlockLayout(
      background: cs.surfaceContainerLowest,
      backdrop: ShapeBloomBackdrop(
        color: cs.surfaceContainerHighest,
        // Softer, rounder shapes than the update page's, on the stiffest
        // spring with the longest hold: it should read as breathing rather
        // than working.
        from: MaterialShapes.clamShell,
        to: MaterialShapes.cookie7Sided,
        motion: const MaterialSpringMotion.standardSpatialSlow(),
        restBetween: const Duration(milliseconds: 4200),
        opacity: 0.65,
      ),
      eyebrow: const _MaintenanceChip(),
      title: 'BunPod is taking a short break',
      body: message ?? 'Back before your next episode ends.',
      titleStyle: text.headlineMedium?.copyWith(
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.4,
      ),
      bodyStyle: text.bodyLarge?.copyWith(
        color: cs.onSurfaceVariant.withValues(alpha: 0.72),
        height: 1.4,
      ),
      actions: <Widget>[
        SizedBox(
          height: 60,
          child: OutlinedButton(
            onPressed: checking ? null : onRetry,
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.onSurfaceVariant,
              side: BorderSide(color: cs.outlineVariant),
              shape: const StadiumBorder(),
              textStyle: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            child: checking
                ? SizedBox.square(
                    dimension: 32,
                    child: FittedBox(
                      child: LoadingIndicator(
                        activeIndicatorColor: cs.onSurfaceVariant,
                        containerColor: Colors.transparent,
                        semanticsLabel: 'Checking',
                      ),
                    ),
                  )
                : const Text('Try again'),
          ),
        ),
      ],
    );
  }
}

/// Why the app is off. Neutral, with a leading glyph so it reads as a labelled
/// state rather than a stray pill.
class _MaintenanceChip extends StatelessWidget {
  const _MaintenanceChip();

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 16, 6),
        decoration: ShapeDecoration(
          color: cs.surfaceContainerHigh,
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.pause_rounded,
              size: 18,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(width: 7),
            Text(
              'Maintenance',
              style: text.labelLarge?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
