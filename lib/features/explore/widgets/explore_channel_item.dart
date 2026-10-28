import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

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
              child: BlocBuilder<SubscriptionsCubit, List<Channel>?>(
                bloc: locator<SubscriptionsCubit>(),
                builder: (context, subscriptions) {
                  return _Cover(
                    image: channel.image ?? '',
                    subscribed: (subscriptions ?? []).any(
                      (c) => c.appleId == channel.appleId,
                    ),
                  );
                },
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

class _Cover extends StatelessWidget {
  const _Cover({required this.image, required this.subscribed});

  final String image;
  final bool subscribed;

  static final MaterialShapeBorder _square = MaterialShapeBorder(
    shape: MaterialShapes.square,
  );
  static final MaterialShapeBorder _cover = MaterialShapeBorder(
    shape: ShapeValues.cover,
  );

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.expressiveSpatialFast(),
      value: subscribed ? 1.0 : 0.0,
      active: !MediaQuery.disableAnimationsOf(context),
      builder: (context, t, image) {
        final double tc = t.clamp(0.0, 1.0);

        return Stack(
          fit: .expand,
          children: [
            ClipPath(
              clipper: ShapeBorderClipper(
                shape: _square.lerpTo(_cover, tc) ?? _square,
              ),
              child: image,
            ),
            Positioned(
              top: 2,
              right: 2,
              child: Transform.scale(
                scale: tc,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: .circle,
                    border: .all(color: cs.surface, width: 2),
                  ),
                  child: Padding(
                    padding: const .all(4),
                    child: Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: SmoothImage(url: image, placeholderColor: cs.surfaceContainerHigh),
    );
  }
}
