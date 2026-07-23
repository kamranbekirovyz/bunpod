import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

/// Favorite toggle. A tonal circle that blooms into a tertiary gem when faved.
/// While pressed it previews the toggled result, then settles there on release.
class FavButton extends StatefulWidget {
  const FavButton({
    super.key,
    required this.fav,
    required this.scheme,
    required this.onTap,
  });

  final bool fav;
  final ColorScheme scheme;
  final VoidCallback onTap;

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
  bool _down = false;

  void _setDown(bool value) {
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = widget.scheme;
    final bool reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final bool effective = _down && !reduce ? !widget.fav : widget.fav;

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.expressiveSpatialFast(),
      value: effective ? 1.0 : 0.0,
      builder: (context, t, child) {
        final Color bg = Color.lerp(
          cs.surfaceContainerHighest,
          cs.tertiary,
          t.clamp(0.0, 1.0),
        )!;

        return ClipPath(
          clipper: ShapeBorderClipper(
            shape: _shapeAt(t),
          ),
          child: Material(
            color: bg,
            child: child,
          ),
        );
      },
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
              effective
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: effective ? cs.onTertiary : cs.onSurface,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  ShapeBorder _shapeAt(double t) {
    final MaterialShapeBorder circle = MaterialShapeBorder(
      shape: MaterialShapes.circle,
    );

    if (t <= 0) return circle;
    final MaterialShapeBorder bloom = MaterialShapeBorder(
      shape: MaterialShapes.gem,
    );

    if (t >= 1) return bloom;

    return circle.lerpTo(bloom, t)!;
  }
}
