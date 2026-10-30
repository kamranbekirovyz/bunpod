/// A library for creating and morphing custom Material-style shapes with
/// transformations and path conversion utilities for rendering.
library;

export 'src/material_shape_border.dart' show MaterialShapeBorder;
export 'src/material_shapes.dart' show MaterialShapes;
export 'src/shapes/shapes.dart'
    show
        CornerRounding,
        Cubic,
        Matrix4PointTransformer,
        Morph,
        MorphToPathExtension,
        RoundedPolygon,
        RoundedPolygonToPathExtension,
        pathFromCubics;
