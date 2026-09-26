import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
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
        // Swap the `//` to check a language that puts the link mid-sentence.
        // Nothing in the layout knows where the link falls, which is the whole
        // point of marking it inline instead of splitting the string in three.
        // text: 'By continuing you agree to <link>Terms and Privacy</link>.',
        text:
            'Davam etməklə <link>Şərtlər və Məxfilik</link> qaydalarını '
            'qəbul etmiş olursunuz.',
        style: text.bodySmall!.copyWith(
          color: cs.onSurfaceVariant,
        ),
        linkColor: cs.primary,
        onTap: (_) {
          launchUrl(
            Uri.parse(AppValues.legalUrl),
            mode: .externalApplication,
          );
        },
      ),
    );
  }
}
