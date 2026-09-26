import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

/// A filled M3 shape that springs between [from] and [to], rests, then springs
/// back.
///
/// The morph runs on [motion] rather than a curve, so the shape arrives with
/// real spring physics — a quick settle with a little overshoot in it — and the
/// pace is set by choosing a motion, not by naming a duration. [restBetween] is
/// the beat it holds at each end, which is what separates an eager accent from
/// a sleeping one.
///
/// The [child] never rotates, so a directional icon keeps pointing where it
/// means to. [turns] defaults to none for the same reason.
class MorphingShapeBadge extends StatefulWidget {
  const MorphingShapeBadge({
    super.key,
    required this.size,
    required this.from,
    required this.to,
    required this.color,
    required this.child,
    this.motion = const MaterialSpringMotion.expressiveSpatialDefault(),
    this.restBetween = const Duration(milliseconds: 700),
    this.turns = 0,
  });

  final double size;
  final RoundedPolygon from;
  final RoundedPolygon to;
  final Color color;
  final Widget child;

  /// The spring the morph rides. Bouncier reads as eager, stiffer as calm.
  final Motion motion;

  /// How long the shape holds at each end before springing back.
  final Duration restBetween;

  /// How far the shape turns at full morph, in turns. Leave at 0 whenever the
  /// child points somewhere.
  final double turns;

  @override
  State<MorphingShapeBadge> createState() => _MorphingShapeBadgeState();
}

class _MorphingShapeBadgeState extends State<MorphingShapeBadge> {
  double _target = 0;
  bool _reduceMotion = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _scheduleFlip();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    // Held at its resting shape under reduced motion: the badge still reads as
    // a shape, it just stops breathing.
    if (_reduceMotion) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// The spring has settled at one end — wait out the beat, then head back.
  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.forward ||
        status == AnimationStatus.reverse) {
      return;
    }

    _scheduleFlip();
  }

  void _scheduleFlip() {
    _timer?.cancel();

    if (_reduceMotion) return;

    _timer = Timer(widget.restBetween, () {
      if (!mounted || _reduceMotion) return;

      setState(() => _target = _target == 0 ? 1 : 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: SingleMotionBuilder(
        motion: widget.motion,
        value: _reduceMotion ? 0 : _target,
        active: !_reduceMotion,
        onAnimationStatusChanged: _onStatusChanged,
        child: Center(child: widget.child),
        builder: (BuildContext context, double t, Widget? child) {
          // The spring overshoots past both ends; the shape lerp is only
          // defined between them.
          final double tc = t.clamp(0.0, 1.0);

          final ShapeBorder shape = MaterialShapeBorder(
            shape: widget.from,
          ).lerpTo(MaterialShapeBorder(shape: widget.to), tc)!;

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(
                child: Transform.rotate(
                  angle: tc * widget.turns * 2 * math.pi,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: widget.color,
                      shape: shape,
                    ),
                  ),
                ),
              ),
              child!,
            ],
          );
        },
      ),
    );
  }
}
