import 'package:bunpod/bunpod.dart';
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;

class MenuMoveShows extends StatelessWidget {
  const MenuMoveShows({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    const Radius outer = .circular(MenuSection.outerRadius);
    const Radius inner = .circular(MenuSection.innerRadius);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: _MoveCard(
              title: 'Move in',
              subtitle: 'From another app',
              icon: Icons.south_west_rounded,
              shape: MaterialShapes.cookie4Sided,
              background: cs.primaryContainer,
              foreground: cs.onPrimaryContainer,
              badge: cs.primary,
              onBadge: cs.onPrimary,
              borderRadius: const .horizontal(
                left: outer,
                right: inner,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) {
                      return const OpmlImportPage();
                    },
                  ),
                );

                locator<SubscriptionsCubit>().load();
              },
            ),
          ),
          MenuSection.tileGap.gap,
          Expanded(
            child: _MoveCard(
              title: 'Move out',
              subtitle: 'To another app',
              icon: Icons.north_east_rounded,
              shape: MaterialShapes.clover4Leaf,
              background: cs.tertiaryContainer,
              foreground: cs.onTertiaryContainer,
              badge: cs.tertiary,
              onBadge: cs.onTertiary,
              borderRadius: const .horizontal(
                left: inner,
                right: outer,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) {
                      return const OpmlExportPage();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MoveCard extends StatelessWidget {
  const _MoveCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.shape,
    required this.background,
    required this.foreground,
    required this.badge,
    required this.onBadge,
    required this.borderRadius,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final RoundedPolygon shape;
  final Color background;
  final Color foreground;
  final Color badge;
  final Color onBadge;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;

    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: .center,
                decoration: ShapeDecoration(
                  color: badge,
                  shape: MaterialShapeBorder(
                    shape: shape,
                  ),
                ),
                child: Icon(
                  icon,
                  color: onBadge,
                ),
              ),
              24.gap,
              Text(
                title,
                style: GoogleFonts.unbounded(
                  textStyle: tt.titleMedium,
                  fontWeight: .w700,
                  color: foreground,
                ),
              ),
              2.gap,
              Text(
                subtitle,
                style: tt.bodyMedium?.copyWith(
                  color: foreground.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
