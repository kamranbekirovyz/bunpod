import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

/// One oversized M3 shape anchored off the bottom-left corner, morphing on a
/// slow spring.
///
/// This is the expressive layer of a screen that would otherwise be a flat
/// colour: it puts something behind the content so the content reads as being
/// *on* something, without a shape in the middle repeating the point.
///
/// Kept far below the content in contrast on purpose. The moment a backdrop is
/// legible it stops being a backdrop and starts being a thing to read.
class ShapeBloomBackdrop extends StatelessWidget {
  const ShapeBloomBackdrop({
    super.key,
    required this.color,
    required this.from,
    required this.to,
    this.motion = const MaterialSpringMotion.standardSpatialSlow(),
    this.restBetween = const Duration(milliseconds: 1500),
    this.opacity = 0.3,
  });

  /// Usually a container tone. Alpha does the rest.
  final Color color;

  final RoundedPolygon from;
  final RoundedPolygon to;

  /// Each screen picks its own, so two pages using this never breathe alike.
  final Motion motion;
  final Duration restBetween;

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: -190,
          left: -160,
          child: MorphingShapeBadge(
            size: 380,
            from: from,
            to: to,
            color: color.withValues(alpha: opacity),
            motion: motion,
            restBetween: restBetween,
            child: const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
