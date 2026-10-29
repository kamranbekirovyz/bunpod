import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({
    super.key,
    required this.playing,
    required this.loading,
    required this.color,
    required this.foreground,
    required this.onTap,
  });

  final bool playing;
  final bool loading;
  final Color color;
  final Color foreground;
  final VoidCallback onTap;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  static const double _pressedRadius = 16; // M3 large-button pressed corner.

  bool _down = false;

  void _setDown(bool value) {
    if (_down != value) {
      setState(() => _down = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double roundRadius = constraints.biggest.shortestSide / 2;
        final double pausedRadius = roundRadius * 0.42;
        final double target = _down && !reduce
            ? _pressedRadius
            : (widget.playing ? roundRadius : pausedRadius);

        return SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialFast(),
          value: target,
          builder: (context, radius, child) {
            return ClipPath(
              clipper: ShapeBorderClipper(
                shape: RoundedSuperellipseBorder(
                  borderRadius: .circular(
                    radius.clamp(0.0, roundRadius),
                  ),
                ),
              ),
              child: child,
            );
          },
          child: Material(
            color: widget.color,
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: (_) {
                _setDown(true);
              },
              onTapUp: (_) {
                _setDown(false);
              },
              onTapCancel: () {
                _setDown(false);
              },
              child: SizedBox.expand(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: widget.loading
                        ? SizedBox.square(
                            key: const ValueKey('loading'),
                            dimension: 72,
                            child: LoadingIndicator(
                              activeIndicatorColor: widget.foreground,
                            ),
                          )
                        : Icon(
                            widget.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            key: ValueKey(widget.playing),
                            color: widget.foreground,
                            size: 56,
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
