import 'package:bunpod/bunpod.dart';
import 'package:expressive_sheet/expressive_sheet.dart';
import 'package:flutter/material.dart';

class AuthSheet extends StatelessWidget {
  const AuthSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showExpressiveSheet<void>(
      context: context,
      builder: (context) {
        return const AuthSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: .fromLTRB(16, 0, 16, BottomPadding.of(context)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
        ),
        child: Material(
          color: cs.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            // Concentric with the round buttons behind 24 padding.
            borderRadius: .circular(52),
          ),
          clipBehavior: .antiAlias,
          child: Padding(
            padding: const .all(24),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                8.gap,
                Text(
                  'Tune in.',
                  textAlign: .center,
                  style: tt.headlineLarge?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                24.gap,
                GoogleSignInButton(),
                8.gap,
                AppleSignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
