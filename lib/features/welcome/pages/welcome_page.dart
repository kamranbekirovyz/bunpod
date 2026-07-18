import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:bunpod_flutter/features/welcome/widgets/channel_wall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The first impression of BunPod: a living wall of channel artwork behind a
/// scrim, the wordmark, a short promise, and a single clear action. The
/// foreground copy and CTA are static — only the wall animates. The wall stays
/// tappable (tap a cover to reshape it) because the overlays above it are
/// hit-transparent: the scrim is wrapped in [IgnorePointer] and the copy/CTA are
/// bottom-anchored rather than filling the screen.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, this.onStart});

  final VoidCallback? onStart;

  void _start(BuildContext context) {
    if (onStart != null) {
      onStart!();
      return;
    }
    AuthSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // ── Living channel wall (interactive) ─────────────────────────
          ChannelWall(channels: mockChannels),

          // ── Scrim: fade to solid where the copy and CTA live so text stays
          //    legible. A dark veil over the mosaic reads as moody depth, but a
          //    light veil just makes the covers look washed out — so in light
          //    mode we keep the top clear and let the art stay vibrant.
          //    IgnorePointer so it never eats taps meant for the wall. ────────
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
            ),
          ),

          // ── Foreground (static, bottom-anchored) ──────────────────────
          //    Only occupies the bottom, so the top mosaic stays tappable.
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  24.gap,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SvgPicture.asset(
                        isDark
                            ? AssetValues.logoHorizontalDark
                            : AssetValues.logoHorizontalLight,
                        height: 40,
                      ),
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
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: () => _start(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      minimumSize: const Size.fromHeight(60),
                      shape: const StadiumBorder(),
                      textStyle: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Start Listening'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
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
