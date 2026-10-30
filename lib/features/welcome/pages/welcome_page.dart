import 'package:bunpod/bunpod.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    this.returning = false,
  });

  /// Someone who just logged out, so the copy welcomes them back.
  final bool returning;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: .expand,
        children: <Widget>[
          ChannelWall(
            channels: mockChannels,
          ),

          // Scrim
          const IgnorePointer(
            child: WelcomeScrim(),
          ),

          // Foreground
          Align(
            alignment: .bottomCenter,
            child: Padding(
              padding: const .symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                children: <Widget>[
                  24.gap,
                  Column(
                    crossAxisAlignment: .start,
                    children: <Widget>[
                      const WelcomeLogo(),
                      const SizedBox(height: 20),
                      Text(
                        returning
                            ? 'Paused, not stopped.'
                            : 'Podcasts, meet expression.',
                        style: text.headlineMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        returning
                            ? 'Pick up right where you left off.'
                            : 'Pick a few shows and press play.',
                        style: text.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _Button(
                    returning: returning,
                  ),
                  // Android signs in straight from this button, so this is the
                  // last screen before an account exists and the small print
                  // has to be here. iOS opens [AuthSheet] instead, which
                  // carries its own copy right above the buttons that matter.
                  if (defaultTargetPlatform == .android) ...[
                    12.gap,
                    const LegalNote(),
                  ],
                  const BottomPadding(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.returning,
  });

  final bool returning;

  @override
  Widget build(BuildContext context) {
    final bool isAndroid = defaultTargetPlatform == .android;

    // Android has only Google Sign In, no need to open AuthSheet
    if (isAndroid) {
      return GoogleSignInButton();
    }

    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return FilledButton(
      onPressed: () {
        AuthSheet.show(context);
      },
      style: FilledButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        minimumSize: const .fromHeight(64),
        shape: const StadiumBorder(),
        textStyle: text.titleMedium?.copyWith(
          fontWeight: .w700,
        ),
      ),
      child: Row(
        mainAxisAlignment: .center,
        children: <Widget>[
          Text(
            returning ? 'Sign back in' : 'Start listening',
          ),
          8.gap,
          Icon(
            Icons.arrow_forward_rounded,
            size: 20,
          ),
        ],
      ),
    );
  }
}
