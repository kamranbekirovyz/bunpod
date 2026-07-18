import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';

class ResultTile extends StatelessWidget {
  const ResultTile({
    super.key,
    required this.channel,
    required this.onTap,
  });

  final Channel channel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: '${channel.name} by ${channel.host}',
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
                  url: channel.image,
                  placeholderColor: channel.seed,
                ),
              ),
            ),
            8.gap,
            Text(
              channel.name,
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
