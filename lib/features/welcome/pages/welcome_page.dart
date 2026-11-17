import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

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
          const ChannelWall(
            covers: welcomeCovers,
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
                        'Podcasts, meet expression.',
                        style: text.headlineMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Pick a few shows and press play.',
                        style: text.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const _Button(),
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

  Future<void> _start(BuildContext context) async {
    await locator<PreferencesLocalData>().cacheWelcomed();

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) {
          return const FeedPage();
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return FilledButton(
      onPressed: () => _start(context),
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
          const Text('Start listening'),
          8.gap,
          const Icon(
            Icons.arrow_forward_rounded,
            size: 20,
          ),
        ],
      ),
    );
  }
}
