import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeLogo extends StatelessWidget {
  const WelcomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == .dark;

    return SvgPicture.asset(
      isDark ? AssetValues.logoHorizontalDark : AssetValues.logoHorizontalLight,
      height: 40,
    );
  }
}
