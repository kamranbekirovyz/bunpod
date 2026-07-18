import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

/// A full-width sign-in button with the M3 expressive press morph: round at
/// rest, springing to a rounded square while pressed.
///
/// While [loading], the content is replaced by a [LoadingIndicator] and taps
/// are ignored. While not [enabled], the button fades and ignores taps.
class MorphSignInButton extends StatefulWidget {
  const MorphSignInButton({
    super.key,
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.loading = false,
    this.enabled = true,
  });

  final Widget icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final bool loading;
  final bool enabled;

  @override
  State<MorphSignInButton> createState() => _MorphSignInButtonState();
}

class _MorphSignInButtonState extends State<MorphSignInButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  bool get _interactive => widget.enabled && !widget.loading;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.standardSpatialFast(),
      value: _pressed ? 1.0 : 0.0,
      active: !reduceMotion,
      builder: (BuildContext context, double t, Widget? child) {
        final double tc = t.clamp(0.0, 1.0);
        final BorderRadius radius = .circular(32 - 12 * tc);

        return Transform.scale(
          scale: 1 - 0.03 * tc,
          child: AnimatedOpacity(
            opacity: widget.enabled ? 1 : 0.45,
            duration: kThemeAnimationDuration,
            child: Material(
              color: widget.background,
              borderRadius: radius,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: _interactive ? widget.onTap : null,
                onHighlightChanged: _setPressed,
                child: child,
              ),
            ),
          ),
        );
      },
      child: SizedBox(
        height: 64,
        child: widget.loading
            ? Center(
                child: SizedBox.square(
                  dimension: 40,
                  child: FittedBox(
                    child: LoadingIndicator(
                      activeIndicatorColor: widget.foreground,
                      containerColor: Colors.transparent,
                      semanticsLabel: 'Signing in',
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: .center,
                children: <Widget>[
                  widget.icon,
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: tt.titleMedium?.copyWith(
                      color: widget.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
