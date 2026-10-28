import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';

class ExploreChannelItem extends StatelessWidget {
  const ExploreChannelItem({
    super.key,
    required this.channel,
  });

  final ChannelPreview channel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: '${channel.title} by ${channel.author}',
      child: GestureDetector(
        behavior: .opaque,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) {
                return ChannelPage(
                  appleId: channel.appleId,
                  preview: channel,
                );
              },
            ),
          );
        },
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
                  url: channel.image ?? '',
                  placeholderColor: cs.surfaceContainerHigh,
                ),
              ),
            ),
            8.gap,
            Text(
              channel.title ?? '',
              textAlign: .center,
              maxLines: 2,
              overflow: .ellipsis,
              style: tt.labelLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: .w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
