import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

import 'snack.dart';
import 'snack_overlay.dart';

/// One pill: entry and exit springs, its place in the card stack, drag and
/// tap to dismiss, and the duplicate message shake.
class SnackView extends StatefulWidget {
  const SnackView({super.key, required this.snack, required this.depth});

  final Snack snack;

  /// Steps behind the front pill: raised and shrunk this many notches.
  final int depth;

  @override
  State<SnackView> createState() => SnackViewState();
}

class SnackViewState extends State<SnackView> with TickerProviderStateMixin {
  // Distance the pill travels from its offscreen resting point, in px.
  static const double _travel = 160;
  // Past this offset, or any real downward fling, a released drag closes
  // the pill. Kept forgiving on purpose: a short quick swipe is enough.
  static const double _dismissOffset = 24;
  static const double _dismissVelocity = 300;
  // How far each depth step peeks above the pill in front, and how much
  // smaller it renders. The usual card stack recipe.
  static const double _peek = 12;
  static const double _shrink = 0.05;
  // How much of the theme's shadow color each depth step lays over a pill.
  // The pills share one surface color, so without this the stacked ones
  // melt into each other.
  static const double _shade = 0.15;
  // Sideways impulse for the duplicate message shake, in px/s. Swings the
  // pill about 15px on the first swing.
  static const double _shakeVelocity = 600;

  // Finger-driven vertical offset; springs back to 0 on a released drag
  // that didn't pass the dismiss threshold.
  late final AnimationController _drag = AnimationController.unbounded(
    vsync: this,
  )..value = 0;

  // Horizontal shake offset; rests at 0 and only moves when [shake] kicks
  // it with an impulse.
  late final AnimationController _shake = AnimationController.unbounded(
    vsync: this,
  )..value = 0;

  bool _visible = false;
  bool _removing = false;
  Timer? _timer;

  /// Whether the exit animation is already running.
  bool get isDismissing => _removing;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
    _timer = Timer(widget.snack.duration, dismiss);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _drag.dispose();
    _shake.dispose();
    super.dispose();
  }

  void dismiss() {
    if (_removing) return;
    _removing = true;
    _timer?.cancel();
    _drag.stop();
    if (mounted) setState(() => _visible = false);
    SnackOverlay.refresh();
    // Leave the list once the exit spring has settled.
    Timer(const Duration(milliseconds: 450), () {
      SnackOverlay.remove(widget.snack);
    });
  }

  /// The duplicate message cue: a sideways velocity impulse into a spring
  /// resting at 0, so the pill wobbles and settles on real physics instead
  /// of a keyframed shake. Also restarts the countdown, since the message
  /// just proved it is still relevant.
  void shake() {
    if (_removing) return;
    _timer?.cancel();
    _timer = Timer(widget.snack.duration, dismiss);
    _shake.animateWith(
      SpringSimulation(
        const MaterialSpringMotion.expressiveSpatialFast().description,
        0,
        0,
        _shakeVelocity,
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    // Holding the pill pauses the auto-dismiss countdown.
    _timer?.cancel();
    _drag.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _drag.value = (_drag.value + details.delta.dy).clamp(0.0, _travel * 2);
  }

  void _onDragEnd(DragEndDetails details) {
    final double velocity = details.velocity.pixelsPerSecond.dy;
    if (_drag.value > _dismissOffset || velocity > _dismissVelocity) {
      dismiss();
      return;
    }
    _settleBack(velocity);
  }

  void _settleBack(double velocity) {
    if (_removing) return;
    _drag.animateWith(
      SpringSimulation(
        const MaterialSpringMotion.standardSpatialFast().description,
        _drag.value,
        0,
        velocity,
      ),
    );
    _timer = Timer(widget.snack.duration, dismiss);
  }

  @override
  Widget build(BuildContext context) {
    final Color shadow = Theme.of(context).colorScheme.shadow;

    // The outer spring chases the dealt depth (moving back or forward in
    // the stack). The inner spring drives entry and exit. Both use the
    // pill's fast bounce.
    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.expressiveSpatialFast(),
      value: widget.depth.toDouble(),
      builder: (context, depth, child) => SingleMotionBuilder(
        // Fast springs: the spec maps the fast speed class to small
        // components, and this pill is one (sheets keep default).
        motion: _visible
            ? const MaterialSpringMotion.expressiveSpatialFast()
            : const MaterialSpringMotion.standardSpatialFast(),
        value: _visible ? 0.0 : 1.0,
        builder: (context, t, child) => AnimatedBuilder(
          animation: Listenable.merge([_drag, _shake]),
          builder: (context, child) => Transform.translate(
            offset: Offset(
              _shake.value,
              t * _travel + _drag.value - depth * _peek,
            ),
            child: Transform.scale(
              scale: (1 - depth * _shrink).clamp(0.0, 1.0),
              alignment: Alignment.bottomCenter,
              // The fade hides a leaving pill crossing the ones behind it.
              // Clamped so it does not wiggle with the spring's overshoot.
              child: Opacity(
                opacity: _removing ? 1 - t.clamp(0.0, 1.0) : 1,
                // The shade rides the depth spring: a pill darkens as it
                // recedes and clears as it comes forward.
                child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: shadow.withValues(
                      alpha: (depth * _shade).clamp(0.0, 0.5),
                    ),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
          child: child,
        ),
        child: child,
      ),
      child: GestureDetector(
        onVerticalDragStart: _onDragStart,
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        onVerticalDragCancel: () => _settleBack(0),
        child: _Pill(snack: widget.snack, onTap: dismiss),
      ),
    );
  }
}

/// The pill itself: an inverse surface stadium with an optional arch
/// shaped icon chip and the message text.
class _Pill extends StatelessWidget {
  const _Pill({required this.snack, required this.onTap});

  final Snack snack;
  final VoidCallback onTap;

  /// [MaterialShapes.arch] turned so its dome points to the text start
  /// side, matching the stadium curve of the pill's end. One per text
  /// direction: the chip sits on the left in LTR and on the right in RTL.
  static final RoundedPolygon _archLtr = _arch(-math.pi / 2);
  static final RoundedPolygon _archRtl = _arch(math.pi / 2);

  static RoundedPolygon _arch(double rotation) {
    return MaterialShapes.arch
        .transformed(
          (Matrix4.identity()..rotateZ(rotation)).asPointTransformer(),
        )
        .normalized();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final IconData? icon = snack.icon;
    final bool ltr = Directionality.of(context) == TextDirection.ltr;

    return Material(
      color: cs.inverseSurface,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          // Both paddings land on the spec's 48dp single line container
          // height: 8dp around the 32dp chip, or 14dp around the 20dp
          // body medium line when there is no chip.
          padding: icon != null
              ? const EdgeInsetsDirectional.fromSTEB(8, 8, 20, 8)
              : const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: ShapeDecoration(
                    color: cs.inversePrimary,
                    shape: MaterialShapeBorder(
                      shape: ltr ? _archLtr : _archRtl,
                    ),
                  ),
                  child: Icon(icon, size: 18, color: cs.inverseSurface),
                ),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    snack.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onInverseSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
