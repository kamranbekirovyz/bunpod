import 'package:flutter/material.dart';

class WelcomeScrim extends StatelessWidget {
  const WelcomeScrim({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == .dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: .topCenter,
          end: .bottomCenter,
          colors: isDark
              ? <Color>[
                  cs.surface.withValues(alpha: 0.30),
                  cs.surface.withValues(alpha: 0.55),
                  cs.surface.withValues(alpha: 0.94),
                  cs.surface,
                ]
              : <Color>[
                  cs.surface.withValues(alpha: 0.0),
                  cs.surface.withValues(alpha: 0.0),
                  cs.surface.withValues(alpha: 0.88),
                  cs.surface,
                ],
          stops: isDark
              ? const <double>[0.0, 0.42, 0.72, 0.9]
              : const <double>[0.0, 0.46, 0.74, 0.88],
        ),
      ),
    );
  }
}
