import 'package:bunpod/bunpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
                        'A world in every voice.',
                        style: text.headlineMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'The ideas that quietly shape a life are being '
                        'spoken now. Begin by listening.',
                        style: text.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _Button(),
                  8.gap,
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
  const _Button();

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
            'Start Listening',
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
