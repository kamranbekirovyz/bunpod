import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';

class CategoryPill extends StatelessWidget {
  const CategoryPill({
    super.key,
    required this.category,
    required this.onClear,
  });

  final ExploreCategory category;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = category.scheme(context);
    final TextTheme tt = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: scheme.primaryContainer,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onClear,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
            child: Row(
              mainAxisSize: .min,
              children: [
                Text(
                  category.name,
                  style: tt.labelLarge?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                6.gap,
                Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: scheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
