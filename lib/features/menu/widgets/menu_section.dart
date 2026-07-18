import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A labelled group of [MenuTile]s in the Android 16 Settings style: 28dp
/// corners on the group's outer edges, 4dp on the inner seams, tiles
/// separated by a 2dp gap.
class MenuSection extends StatelessWidget {
  const MenuSection({super.key, this.label, required this.children});

  static const double outerRadius = 28;
  static const double innerRadius = 4;
  static const double tileGap = 2;

  final String? label;
  final List<MenuTile> children;

  BorderRadius _radiusFor(int index) {
    const Radius outer = .circular(outerRadius);
    const Radius inner = .circular(innerRadius);

    return .vertical(
      top: index == 0 ? outer : inner,
      bottom: index == children.length - 1 ? outer : inner,
    );
  }

  MenuTile _positioned(MenuTile tile, int index) {
    return MenuTile(
      key: tile.key,
      icon: tile.icon,
      title: tile.title,
      subtitle: tile.subtitle,
      trailing: tile.trailing,
      onTap: tile.onTap,
      background: tile.background,
      foreground: tile.foreground,
      borderRadius: _radiusFor(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (label != null)
          Padding(
            padding: const .fromLTRB(16, 0, 16, 12),
            child: Text(
              label!,
              style: GoogleFonts.unbounded(
                textStyle: tt.labelLarge,
                fontWeight: .w600,
                letterSpacing: -0.3,
                color: cs.primary,
              ),
            ),
          ),
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) tileGap.gap,
          _positioned(children[i], i),
        ],
      ],
    );
  }
}
