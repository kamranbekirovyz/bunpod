import 'package:flutter/painting.dart';
import 'package:material_shapes/material_shapes.dart';

abstract final class ShapeValues {
  static final RoundedPolygon cover = MaterialShapes.clover4Leaf;
  static final RoundedPolygon coverFocused = MaterialShapes.cookie7Sided;

  static ShapeBorder coverBorder(double t) {
    final double tc = t.clamp(0.0, 1.0);
    final MaterialShapeBorder normal = MaterialShapeBorder(shape: cover);
    if (tc <= 0) return normal;
    final MaterialShapeBorder focused = MaterialShapeBorder(
      shape: coverFocused,
    );
    if (tc >= 1) return focused;

    return normal.lerpTo(focused, tc)!;
  }
}
