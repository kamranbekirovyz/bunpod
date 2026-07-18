import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_shapes/material_shapes.dart';

/// Menu page header: big round profile picture with stat badges, name below.
class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: ShapeBorderClipper(
                  shape: MaterialShapeBorder(
                    shape: MaterialShapes.pill,
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: SmoothImage(
                    url: AppValues.makerImageUrl,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: _StatBadge(
                  value: '128h',
                  label: 'listened',
                  shape: MaterialShapes.sunny,
                  background: cs.tertiaryContainer,
                  foreground: cs.onTertiaryContainer,
                  angle: -0.14,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: _StatBadge(
                  value: '342',
                  label: 'episodes',
                  shape: MaterialShapes.cookie9Sided,
                  background: cs.primaryContainer,
                  foreground: cs.onPrimaryContainer,
                  angle: 0.14,
                ),
              ),
            ],
          ),
          24.gap,
          Text(
            AppValues.makerName,
            textAlign: TextAlign.center,
            style: tt.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tilted shape badge showing one stat: number on top, label under it.
class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  final RoundedPolygon shape;
  final Color background;
  final Color foreground;
  final double angle;

  const _StatBadge({
    required this.value,
    required this.label,
    required this.shape,
    required this.background,
    required this.foreground,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;

    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 108,
        height: 108,
        decoration: ShapeDecoration(
          color: background,
          shape: MaterialShapeBorder(
            shape: shape,
          ),
        ),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              value,
              style: GoogleFonts.unbounded(
                textStyle: tt.titleLarge,
                fontWeight: .w700,
                letterSpacing: -0.5,
                color: foreground,
              ),
            ),
            Text(
              label,
              style: tt.labelSmall?.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}
