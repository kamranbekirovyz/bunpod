import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';

class ExploreShowTile extends StatelessWidget {
  const ExploreShowTile({
    super.key,
    required this.show,
    required this.onTap,
  });

  final ChannelPreview show;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: '${show.title} by ${show.author}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: MaterialShapeBorder(
                    shape: MaterialShapes.square,
                  ),
                ),
                child: SmoothImage(
                  url: show.image ?? '',
                  placeholderColor: cs.surfaceContainerHigh,
                ),
              ),
            ),
            8.gap,
            Text(
              show.title ?? '',
              style: tt.labelLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
