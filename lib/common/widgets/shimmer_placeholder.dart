import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

const Duration _loop = Duration(milliseconds: 2000);
const double _sweepMs = 800;
const Cubic _sweepEasing = Cubic(0.3, 0, 0.7, 1);

/// Drives every [ShimmerPlaceholder] below it from one clock, so they sweep
/// together.
class ShimmerScope extends StatefulWidget {
  const ShimmerScope({super.key, this.active = true, required this.child});

  final bool active;
  final Widget child;

  @override
  State<ShimmerScope> createState() => _ShimmerScopeState();
}

class _ShimmerScopeState extends State<ShimmerScope>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _loop,
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _controller.repeat();
  }

  @override
  void didUpdateWidget(ShimmerScope old) {
    super.didUpdateWidget(old);
    if (widget.active == old.active) return;
    widget.active ? _controller.repeat() : _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ShimmerClock(
      notifier: _controller,
      child: widget.child,
    );
  }
}

class _ShimmerClock extends InheritedNotifier<AnimationController> {
  const _ShimmerClock({required super.notifier, required super.child});
}

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({
    super.key,
    this.shape = const StadiumBorder(),
    this.width,
    this.height,
  });

  final ShapeBorder shape;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    final AnimationController? clock = context
        .getInheritedWidgetOfExactType<_ShimmerClock>()
        ?.notifier;

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _ShimmerPainter(
          context: context,
          clock: reduceMotion ? null : clock,
          shape: shape,
          color: Color.alphaBlend(
            cs.onSurface.withValues(alpha: 0.1),
            cs.surfaceContainer,
          ),
          // Wear is dark only, where onSurface is the light tone. In light
          // mode that would sweep dark, so use the lightest surface instead.
          shimmerColor: cs.brightness == Brightness.dark
              ? cs.onSurface
              : cs.surfaceContainerLowest,
          screen: MediaQuery.sizeOf(context).longestSide,
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  _ShimmerPainter({
    required this.context,
    required this.clock,
    required this.shape,
    required this.color,
    required this.shimmerColor,
    required this.screen,
  }) : super(repaint: clock);

  final BuildContext context;
  final AnimationController? clock;
  final ShapeBorder shape;
  final Color color;
  final Color shimmerColor;
  final double screen;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Path path = shape.getOuterPath(rect);

    canvas.drawPath(path, Paint()..color = color);

    final AnimationController? clock = this.clock;
    final RenderObject? box = context.findRenderObject();

    if (clock == null || box is! RenderBox || !box.attached) return;

    final double ms = clock.value * _loop.inMilliseconds;
    final double progress = math.min(ms, _sweepMs) / _sweepMs;
    final double alpha = 0.5 - (0.5 - progress).abs();

    if (alpha <= 0) return;

    final double position = _lerp(
      -screen * 0.5,
      screen * 1.5,
      _sweepEasing.transform(progress),
    );
    final double half = screen * math.pow(2, 1.5) / 2;
    final Offset origin = box.localToGlobal(Offset.zero);
    final Offset center = Offset(position, position) - origin;

    final Paint shimmer = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              shimmerColor.withValues(alpha: 0),
              shimmerColor.withValues(alpha: alpha),
              shimmerColor.withValues(alpha: 0),
            ],
            stops: const [0.1, 0.65, 0.9],
          ).createShader(
            Rect.fromPoints(
              center - Offset(half, half),
              center + Offset(half, half),
            ),
          );

    canvas.drawPath(path, shimmer);
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldRepaint(_ShimmerPainter old) {
    return old.clock != clock ||
        old.shape != shape ||
        old.color != color ||
        old.shimmerColor != shimmerColor ||
        old.screen != screen;
  }
}

class ShimmerReveal extends StatefulWidget {
  const ShimmerReveal({
    super.key,
    required this.loading,
    required this.placeholder,
    required this.child,
    this.delay = Duration.zero,
  });

  final bool loading;
  final Widget placeholder;
  final Widget child;
  final Duration delay;

  @override
  State<ShimmerReveal> createState() => _ShimmerRevealState();
}

class _ShimmerRevealState extends State<ShimmerReveal>
    with SingleTickerProviderStateMixin {
  static const Cubic _wipeOff = Cubic(0, 0.2, 1, 0.6);
  static const double _wipeOffFraction = 80 / 300;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    value: widget.loading ? 0 : 1,
  );

  late bool _revealed = !widget.loading;

  @override
  void didUpdateWidget(ShimmerReveal old) {
    super.didUpdateWidget(old);
    if (old.loading && !widget.loading) _reveal();
    if (!old.loading && widget.loading) {
      _controller.value = 0;
      _revealed = false;
    }
  }

  Future<void> _reveal() async {
    await Future<void>.delayed(widget.delay);
    if (!mounted || widget.loading) return;
    setState(() => _revealed = true);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final double wipeOff = _wipeOff.transform(
          (_controller.value / _wipeOffFraction).clamp(0.0, 1.0),
        );

        return Stack(
          fit: StackFit.passthrough,
          children: [
            Opacity(
              opacity: wipeOff,
              child: SingleMotionBuilder(
                motion: const MaterialSpringMotion.expressiveSpatialDefault(),
                value: _revealed ? 1.0 : 0.88,
                active: !reduceMotion,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: widget.child,
              ),
            ),
            if (wipeOff < 1)
              IgnorePointer(
                child: Opacity(
                  opacity: 1 - wipeOff,
                  child: widget.placeholder,
                ),
              ),
          ],
        );
      },
    );
  }
}
