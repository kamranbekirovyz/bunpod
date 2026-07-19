import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return SocialSignInButton(
      provider: .google,
      icon: Image.asset(
        AssetValues.googleG,
        width: 24,
        height: 24,
      ),
      label: 'Continue with Google',
      background: cs.secondaryContainer,
      foreground: cs.onSecondaryContainer,
    );
  }
}
