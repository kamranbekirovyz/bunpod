import 'dart:async';
import 'dart:math' as math;

import 'package:bunpod/bunpod.dart';
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:motor/motor.dart';

class FeedSyncLogo extends StatefulWidget {
  const FeedSyncLogo({
    super.key,
    required this.syncing,
  });

  final bool syncing;

  @override
  State<FeedSyncLogo> createState() => _FeedSyncLogoState();
}

class _FeedSyncLogoState extends State<FeedSyncLogo> {
  static const List<String> _lines = [
    'Googling…',
    'Fluttering…',
    'Bunning…',
    'Morphing…',
    'Springing…',
    'Squishing…',
    'Wiggling…',
    'Blooming…',
    'Tuning in…',
    'Mic check…',
    'Rewinding…',
    'Buffering…',
    'Recording…',
    'Listening…',
  ];

  static final List<RoundedPolygon> _shapes = [
    MaterialShapes.bun,
    MaterialShapes.cookie4Sided,
    MaterialShapes.clover4Leaf,
    MaterialShapes.flower,
  ];

  Timer? _timer;
  int _hop = 0;
  String _line = _lines.first;
  RoundedPolygon _from = MaterialShapes.bun;
  RoundedPolygon _to = MaterialShapes.bun;

  @override
  void initState() {
    super.initState();

    if (widget.syncing) _start();
  }

  @override
  void didUpdateWidget(FeedSyncLogo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.syncing == oldWidget.syncing) return;

    if (widget.syncing) {
      _start();
    } else {
      _timer?.cancel();
      _hopTo(MaterialShapes.bun);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _line = _lines[math.Random().nextInt(_lines.length)];
    _hopTo(_shapes[(_hop + 1) % _shapes.length]);

    _timer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      setState(() => _hopTo(_shapes[(_hop + 1) % _shapes.length]));
    });
  }

  void _hopTo(RoundedPolygon shape) {
    _from = _to;
    _to = shape;
    _hop++;
  }

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    const Motion fast = MaterialSpringMotion.expressiveSpatialFast();

    return Row(
      mainAxisSize: .min,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: .center,
          decoration: BoxDecoration(
            color: const Color(0xFFFEE086),
            borderRadius: .circular(8.5),
          ),
          child: SizedBox.square(
            dimension: 24,
            child: SingleMotionBuilder(
              motion: widget.syncing
                  ? const MaterialSpringMotion.expressiveSpatialDefault()
                  : fast,
              value: _hop.toDouble(),
              active: !reduceMotion,
              builder: (context, value, child) {
                final double t = (value - _hop + 1).clamp(0.0, 1.0);

                // Half turns keep the bun upright.
                return Transform.rotate(
                  angle: value * math.pi,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: const Color(0xFF564500),
                      shape: MaterialShapeBorder(
                        shape: _from,
                      ).lerpTo(MaterialShapeBorder(shape: _to), t)!,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        12.gap,
        Flexible(
          child: ClipRect(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final bool word = child.key == const ValueKey<bool>(true);

                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, word ? 1 : -1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              layoutBuilder: (current, previous) {
                return Stack(
                  alignment: .centerLeft,
                  children: [...previous, ?current],
                );
              },
              child: Text(
                widget.syncing ? _line : 'BunPod',
                key: ValueKey<bool>(widget.syncing),
                maxLines: 1,
                softWrap: false,
                overflow: .fade,
                style: GoogleFonts.unbounded(
                  fontSize: 27,
                  height: 1.3,
                  fontWeight: .w800,
                  letterSpacing: -0.8,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
