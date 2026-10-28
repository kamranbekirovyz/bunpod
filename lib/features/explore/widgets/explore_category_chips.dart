import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

class ExploreCategoryChips extends StatelessWidget {
  const ExploreCategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<Category> categories;
  final Category? selected;
  final ValueChanged<Category?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const .symmetric(horizontal: 16),
        children: [
          _Chip(
            label: 'All',
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final Category category in categories)
            _Chip(
              label: category.name ?? '',
              selected: category.id == selected?.id,
              onTap: () => onSelected(category),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const .only(right: 8),
      child: SingleMotionBuilder(
        motion: const MaterialSpringMotion.standardSpatialFast(),
        value: selected ? 1.0 : 0.0,
        builder: (context, t, _) {
          final double tc = t.clamp(0.0, 1.0);

          return Material(
            color: Color.lerp(cs.surfaceContainerHigh, cs.primary, tc),
            shape: RoundedRectangleBorder(
              borderRadius: .circular(12 + 8 * t),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const .symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    label,
                    style: tt.labelLarge?.copyWith(
                      color: Color.lerp(cs.onSurfaceVariant, cs.onPrimary, tc),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
