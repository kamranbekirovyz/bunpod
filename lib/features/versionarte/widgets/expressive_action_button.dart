import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

/// Full-width CTA with the M3 expressive press morph: a wide pill at rest
/// springing to a tighter rounded square under the thumb. Shape only — the
/// button holds its size, so nothing shifts under the finger.
///
/// The same shape language as [MorphSignInButton], kept separate because this
/// one is the single hero action of a screen the user cannot leave.
class ExpressiveActionButton extends StatefulWidget {
  const ExpressiveActionButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.background,
    required this.foreground,
    this.icon,
    this.busy = false,
  });

  final String label;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;
  final IconData? icon;
  final bool busy;

  @override
  State<ExpressiveActionButton> createState() => _ExpressiveActionButtonState();
}

class _ExpressiveActionButtonState extends State<ExpressiveActionButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.expressiveSpatialFast(),
      value: _pressed ? 1.0 : 0.0,
      active: !reduceMotion,
      builder: (BuildContext context, double t, Widget? child) {
        final double tc = t.clamp(0.0, 1.0);

        return Material(
          color: widget.background,
          borderRadius: BorderRadius.circular(36 - 16 * tc),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.busy ? null : widget.onTap,
            onHighlightChanged: _setPressed,
            child: child,
          ),
        );
      },
      child: SizedBox(
        height: 68,
        width: double.infinity,
        child: widget.busy
            ? Center(
                child: SizedBox.square(
                  dimension: 40,
                  child: FittedBox(
                    child: LoadingIndicator(
                      activeIndicatorColor: widget.foreground,
                      containerColor: Colors.transparent,
                      semanticsLabel: widget.label,
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.label,
                    style: text.titleMedium?.copyWith(
                      color: widget.foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (widget.icon != null) ...<Widget>[
                    const SizedBox(width: 10),
                    Icon(
                      widget.icon,
                      size: 20,
                      color: widget.foreground,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
