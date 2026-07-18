import 'dart:math' as math;

import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({
    super.key,
    required this.channel,
    required this.borderRadius,
    required this.subscribed,
    required this.onTap,
    required this.onToggle,
  });

  final Channel channel;
  final BorderRadius borderRadius;
  final bool subscribed;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const .fromLTRB(12, 12, 8, 12),
          child: Row(
            children: [
              ClipPath(
                clipper: ShapeBorderClipper(
                  shape: MaterialShapeBorder(
                    shape: ShapeValues.cover,
                  ),
                ),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: SmoothImage(
                    url: channel.image,
                    placeholderColor: channel.seed,
                    placeholderChild: Icon(
                      Icons.podcasts_rounded,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              14.gap,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      channel.host.toUpperCase(),
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: .w700,
                      ),
                    ),
                    2.gap,
                    Text(
                      channel.name,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: tt.bodyLarge,
                    ),
                  ],
                ),
              ),
              8.gap,
              _SubscribeToggle(
                subscribed: subscribed,
                onPressed: onToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubscribeToggle extends StatelessWidget {
  const _SubscribeToggle({
    required this.subscribed,
    required this.onPressed,
  });

  final bool subscribed;
  final VoidCallback onPressed;

  static final MaterialShapeBorder _on = MaterialShapeBorder(
    shape: MaterialShapes.cookie7Sided,
  );
  static final MaterialShapeBorder _off = MaterialShapeBorder(
    shape: MaterialShapes.clover4Leaf,
  );

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Tooltip(
      message: subscribed ? 'Unsubscribe' : 'Subscribe',
      child: InkResponse(
        onTap: onPressed,
        radius: 26,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialFast(),
          value: subscribed ? 0.0 : 1.0,
          builder: (BuildContext context, double t, Widget? child) {
            final double tc = t.clamp(0.0, 1.0);

            return Container(
              width: 44,
              height: 44,
              alignment: .center,
              decoration: ShapeDecoration(
                color: Color.lerp(
                  cs.errorContainer,
                  cs.secondaryContainer,
                  tc,
                ),
                shape: ShapeBorder.lerp(_on, _off, tc) ?? _on,
              ),
              child: Transform.rotate(
                // The X spins a quarter turn into a plus as it flips to off.
                angle: tc * math.pi / 4,
                child: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: Color.lerp(
                    cs.onErrorContainer,
                    cs.onSecondaryContainer,
                    tc,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
