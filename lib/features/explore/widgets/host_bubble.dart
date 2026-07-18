import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

class HostBubble extends StatefulWidget {
  const HostBubble({
    super.key,
    required this.channel,
    required this.onTap,
  });

  final Channel channel;
  final VoidCallback onTap;

  @override
  State<HostBubble> createState() => _HostBubbleState();
}

class _HostBubbleState extends State<HostBubble> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    final TextStyle nameStyle = tt.labelMedium!.copyWith(
      color: cs.onSurface,
      fontWeight: FontWeight.w600,
      height: 1.15,
    );
    // Every bubble reserves two name lines, so one-line names don't get a
    // bigger cover than their two-line neighbours.
    final double nameBlock =
        MediaQuery.textScalerOf(context).scale(nameStyle.fontSize ?? 12) *
        (nameStyle.height ?? 1.2) *
        2;

    return Semantics(
      button: true,
      label: '${widget.channel.host}, ${widget.channel.name}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: SingleMotionBuilder(
          motion: const MaterialSpringMotion.standardSpatialFast(),
          value: _pressed ? 1.0 : 0.0,
          active: !reduceMotion,
          builder: (BuildContext context, double t, Widget? child) {
            return Transform.scale(
              scale: 1 - 0.06 * t.clamp(0.0, 1.0),
              child: child,
            );
          },
          child: Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: MaterialShapeBorder(
                        shape: MaterialShapes.square,
                      ),
                    ),
                    child: SmoothImage(
                      url: widget.channel.image,
                      placeholderColor: widget.channel.seed,
                    ),
                  ),
                ),
              ),
              6.gap,
              SizedBox(
                height: nameBlock,
                child: Text(
                  widget.channel.host,
                  style: nameStyle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
