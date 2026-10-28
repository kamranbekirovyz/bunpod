import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_shapes/material_shapes.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.label,
    required this.count,
    this.topPadding = 28,
  });

  final String label;
  final int count;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, 12),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: cs.primaryContainer,
              shape: MaterialShapeBorder(shape: MaterialShapes.square),
            ),
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: GoogleFonts.unbounded(
                textStyle: tt.labelLarge,
                fontWeight: FontWeight.w700,
                color: cs.onPrimaryContainer,
              ),
            ),
          ),
          12.gap,
          Text(
            label,
            style: GoogleFonts.unbounded(
              textStyle: tt.headlineSmall,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              height: 1.0,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
