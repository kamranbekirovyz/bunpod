import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shared body of the provider sign-in buttons. Creates its own
/// [SocialSignInCubit], so each button owns its loading state and works
/// standalone anywhere.
class SocialSignInButton extends StatefulWidget {
  const SocialSignInButton({
    super.key,
    required this.provider,
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    this.enabled = true,
  });

  final AuthProvider provider;
  final Widget icon;
  final String label;
  final Color background;
  final Color foreground;
  final bool enabled;

  @override
  State<SocialSignInButton> createState() => _SocialSignInButtonState();
}

class _SocialSignInButtonState extends State<SocialSignInButton> {
  late final SocialSignInCubit _socialSignInCubit;

  @override
  void initState() {
    super.initState();
    _socialSignInCubit = SocialSignInCubit(
      widget.provider,
    );
  }

  @override
  void dispose() {
    _socialSignInCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _socialSignInCubit,
      child: BlocConsumer<SocialSignInCubit, ViewState>(
        listener: (context, state) {
          // Clears the sheet route too, so this works standalone as well.
          if (state.isReady) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (_) {
                  return const OnboardingPage();
                },
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final bool isBusy = state is ViewBusy;

          return MorphSignInButton(
            icon: widget.icon,
            label: widget.label,
            background: widget.background,
            foreground: widget.foreground,
            loading: isBusy,
            enabled: widget.enabled && !isBusy,
            onTap: context.read<SocialSignInCubit>().signIn,
          );
        },
      ),
    );
  }
}
