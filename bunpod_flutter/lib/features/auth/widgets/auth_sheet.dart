import 'dart:async';

import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:bunpod_flutter/features/auth/widgets/morph_sign_in_button.dart';
import 'package:expressive_sheet/expressive_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


/// Sign-in as a floating expressive sheet: a headline and two sign-in
/// buttons.
///
/// UI only. Tapping a provider shows a short loading beat, then closes the
/// sheet and replaces the page under it with home. Dragging the sheet away
/// during the beat cancels it.
class AuthSheet extends StatefulWidget {
  const AuthSheet({super.key, this.onSignedIn});

  /// Invoked after the sign-in beat. Defaults to entering the app home.
  final VoidCallback? onSignedIn;

  static Future<void> show(BuildContext context) {
    return showExpressiveSheet<void>(
      context: context,
      builder: (context) => const AuthSheet(),
    );
  }

  @override
  State<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends State<AuthSheet> {
  static const Duration _signInBeat = Duration(seconds: 3);

  Timer? _timer;
  AuthProvider? _signingIn;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _signIn(AuthProvider provider) {
    if (_signingIn != null) return;
    setState(() => _signingIn = provider);

    _timer = Timer(_signInBeat, () {
      if (!mounted) return;
      if (widget.onSignedIn != null) {
        widget.onSignedIn!();
        return;
      }
      final NavigatorState navigator = Navigator.of(context);
      navigator.pop();
      navigator.pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, BottomPadding.of(context)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Material(
          color: cs.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            // Concentric with the round buttons behind 24 padding.
            borderRadius: BorderRadius.circular(52),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                8.gap,
                Text(
                  'Tune in.',
                  textAlign: TextAlign.center,
                  style: tt.headlineLarge?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                24.gap,
                MorphSignInButton(
                  icon: Image.asset(
                    AssetValues.googleG,
                    width: 24,
                    height: 24,
                  ),
                  label: 'Continue with Google',
                  background: cs.secondaryContainer,
                  foreground: cs.onSecondaryContainer,
                  loading: _signingIn == AuthProvider.google,
                  enabled: _signingIn != AuthProvider.apple,
                  onTap: () => _signIn(AuthProvider.google),
                ),
                8.gap,
                MorphSignInButton(
                  icon: SvgPicture.asset(
                    AssetValues.appleLogo,
                    width: 22,
                    height: 22,
                    colorFilter: ColorFilter.mode(cs.surface, BlendMode.srcIn),
                  ),
                  label: 'Continue with Apple',
                  background: cs.onSurface,
                  foreground: cs.surface,
                  loading: _signingIn == AuthProvider.apple,
                  enabled: _signingIn != AuthProvider.google,
                  onTap: () => _signIn(AuthProvider.apple),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
