import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

/// Hero play/pause. One spring drives a single corner radius toward the shape
/// the state calls for — pressed (more square), else playing (circle) or paused
/// (rounded square) — so press and playback changes never fight.
class PlayButton extends StatefulWidget {
  const PlayButton({
    super.key,
    required this.playing,
    required this.color,
    required this.foreground,
    required this.onTap,
  });

  final bool playing;
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
                  child: Icon(
                    widget.playing
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: widget.foreground,
                    size: 48,
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
