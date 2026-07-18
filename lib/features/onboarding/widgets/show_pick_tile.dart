import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

class ShowPickTile extends StatelessWidget {
  const ShowPickTile({
    super.key,
    required this.channel,
    required this.selected,
    required this.onTap,
  });

  final Channel channel;
  final bool selected;
  final VoidCallback onTap;

  static ShapeBorder _morphBorder(double t) {
    final MaterialShapeBorder rest = MaterialShapeBorder(
      shape: MaterialShapes.square,
    );
    if (t <= 0) return rest;
    final MaterialShapeBorder picked = MaterialShapeBorder(
      shape: ShapeValues.cover,
    );
    if (t >= 1) return picked;
    return rest.lerpTo(picked, t)!;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return Semantics(
      button: true,
      selected: selected,
      label: '${channel.name} by ${channel.host}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: SingleMotionBuilder(
                motion: const MaterialSpringMotion.expressiveSpatialFast(),
                value: selected ? 1.0 : 0.0,
                active: !reduceMotion,
                builder: (BuildContext context, double t, Widget? child) {
                  final double tc = t.clamp(0.0, 1.0);

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipPath(
                        clipper: ShapeBorderClipper(shape: _morphBorder(tc)),
                        child: child,
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Transform.scale(
                          scale: tc,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: cs.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: cs.surface, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
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
                child: SmoothImage(
                  url: channel.image,
                  placeholderColor: channel.seed,
                ),
              ),
            ),
            8.gap,
            AnimatedDefaultTextStyle(
              duration: kThemeAnimationDuration,
              style: tt.labelLarge!.copyWith(
                color: selected ? cs.primary : cs.onSurface,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              child: Text(channel.name),
            ),
          ],
        ),
      ),
    );
  }
}
