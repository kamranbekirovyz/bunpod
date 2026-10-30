import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key, this.label, required this.children});

  static const double outerRadius = 28;
  static const double innerRadius = 4;
  static const double tileGap = 2;

  final String? label;
  final List<Widget> children;

  static BorderRadius radiusFor(int index, int length) {
    const Radius outer = .circular(outerRadius);
    const Radius inner = .circular(innerRadius);

    return .vertical(
      top: index == 0 ? outer : inner,
      bottom: index == length - 1 ? outer : inner,
    );
  }

  /// The corners a [MenuTile] gets from its position in the section above it.
  static BorderRadius? radiusOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SectionPosition>()
        ?.borderRadius;
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
          _SectionPosition(
            borderRadius: radiusFor(i, children.length),
            child: children[i],
          ),
        ],
      ],
    );
  }
}

class _SectionPosition extends InheritedWidget {
  const _SectionPosition({required this.borderRadius, required super.child});

  final BorderRadius borderRadius;

  @override
  bool updateShouldNotify(_SectionPosition old) {
    return old.borderRadius != borderRadius;
  }
}
