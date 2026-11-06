import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalNote extends StatelessWidget {
  const LegalNote({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Padding(
      padding: const .symmetric(horizontal: 32),
      child: LinkedText(
        text:
            'By continuing you agree to the <link>Terms</link> and '
            '<link>Privacy Policy</link>.',
        style: text.bodySmall!.copyWith(
          color: cs.onSurfaceVariant,
        ),
        linkColor: cs.primary,
        onTap: (label) {
          launchUrl(
            Uri.parse(
              label == 'Terms' ? AppValues.termsUrl : AppValues.privacyUrl,
            ),
            mode: .externalApplication,
          );
        },
      ),
    );
  }
}
