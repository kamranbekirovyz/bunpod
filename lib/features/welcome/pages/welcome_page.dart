import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      20.gap,
                      Text(
                        'Podcasts, meet expression.',
                        style: text.headlineMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          letterSpacing: -0.4,
                        ),
                      ),
                      12.gap,
                      Text(
                        'Pick a few shows and press play.',
                        style: text.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  32.gap,
                  const _Button(),
                  16.gap,
                  _LegalNote(),
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

class _LegalNote extends StatelessWidget {
  const _LegalNote();

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return LinkedText(
      text: 'By continuing you agree to the <link>Terms</link> and <link>Privacy Policy</link>.',
      style: text.bodySmall!.copyWith(
        color: cs.onSurfaceVariant,
      ),
      linkColor: cs.primary,
      onTap: (label) {
        launchUrl(
          Uri.parse(
            label == 'Terms' ? AppValues.termsUrl : AppValues.privacyUrl,
          ),
        );
      },
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
      onPressed: () {
        _start(context);
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
