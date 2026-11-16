import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:expressive_shapes/expressive_shapes.dart';

class OpmlImportEntryCard extends StatelessWidget {
  const OpmlImportEntryCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(28),
      ),
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const .fromLTRB(12, 12, 16, 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: ShapeDecoration(
                  color: cs.tertiaryContainer,
                  shape: MaterialShapeBorder(
                    shape: MaterialShapes.cookie7Sided,
                  ),
                ),
                child: Icon(
                  Icons.library_add_rounded,
                  size: 22,
                  color: cs.onTertiaryContainer,
                ),
              ),
              14.gap,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      'Switching from another app?',
                      style: tt.titleSmall?.copyWith(fontWeight: .w600),
                    ),
                    2.gap,
                    Text(
                      'Bring all your shows over at once',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              8.gap,
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
