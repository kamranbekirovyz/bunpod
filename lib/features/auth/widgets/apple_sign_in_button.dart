import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return SocialSignInButton(
      provider: .apple,
      icon: SvgPicture.asset(
        AssetValues.appleLogo,
        width: 22,
        height: 22,
        colorFilter: ColorFilter.mode(cs.surface, .srcIn),
      ),
      label: 'Continue with Apple',
      background: cs.onSurface,
      foreground: cs.surface,
    );
  }
}
