import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

/// Drag distance at which the row commits to unsubscribing.
const double _kThreshold = 96;

/// Hard stop for the drag, past the threshold's resistance.
const double _kMaxDrag = 136;

/// Drag left to unsubscribe. The row slides off its background, which fills
/// toward the error container as it goes and grows a blob. The blob morphs
/// from a circle into [MaterialShapes.sunny] right at the commit point, the
/// same shape the downloads delete button and the confirmation sheet use, so
/// the drag previews the sheet it opens.
///
/// Past the threshold the drag gets heavy and a selection tick fires, so you
/// can find the commit point by feel. [onConfirm] runs on release past that
/// point: resolve true and the row stays open for the owner's removal
/// animation, false and it springs shut.
// TODO(kamran): make the drag itself more expressive. Only the blob morphs
// right now; the row is a plain translate on a calm standard spring. Ideas:
//  - Morph the row's own corners as it opens instead of sliding a rigid
//    rectangle.
//  - Expressive springs on release so an uncommitted row snaps back with
//    overshoot.
//  - A heavier haptic on commit, not just the selection tick when it arms.
//  - Read what Compose's SwipeToDismissBox does before inventing our own.
class UnsubscribeSwipe extends StatefulWidget {
  const UnsubscribeSwipe({
    super.key,
    required this.onConfirm,
    required this.borderRadius,
    required this.child,
  });

  /// Runs when the row is released past the commit threshold. True means the
  /// row is going away.
  final Future<bool> Function() onConfirm;

  final BorderRadius borderRadius;
  final Widget child;

  @override
  State<UnsubscribeSwipe> createState() => _UnsubscribeSwipeState();
}

class _UnsubscribeSwipeState extends State<UnsubscribeSwipe>
    with SingleTickerProviderStateMixin {
  late final SingleMotionController _offset = SingleMotionController(
    // The row is chrome, not a hero, so it springs back calm and quick.
    motion: const MaterialSpringMotion.standardSpatialFast(),
    vsync: this,
  );

  static final MaterialShapeBorder _circle = MaterialShapeBorder(
    shape: MaterialShapes.circle,
  );
  static final MaterialShapeBorder _sunny = MaterialShapeBorder(
    shape: MaterialShapes.sunny,
  );

  /// Raw finger travel, before resistance. Kept separate from the rendered
  /// offset so the resistance is applied once instead of compounding every
  /// frame.
  double _raw = 0;
  bool _armed = false;

  /// True while the confirmation sheet is up. The row holds open and ignores
  /// further drags.
  bool _committing = false;

  bool get _reduceMotion =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  @override
  void dispose() {
    _offset.dispose();
    super.dispose();
  }

  /// Rubber-bands past the threshold, so the row goes heavy right where it
  /// commits.
  double _resist(double raw) {
    final double distance = -raw;
    if (distance <= _kThreshold) return raw;

    final double over = (distance - _kThreshold) * 0.35;
    return -math.min(_kThreshold + over, _kMaxDrag);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_committing) return;

    // Only left unsubscribes; dragging right does nothing.
    _raw = math.min(0.0, _raw + details.delta.dx);
    _offset.value = _resist(_raw);

    final bool armed = -_offset.value >= _kThreshold;
    if (armed != _armed) {
      _armed = armed;
      if (armed) HapticFeedback.selectionClick();
    }
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    if (_committing) return;
    if (-_offset.value < _kThreshold) {
      _settle();
      return;
    }

    setState(() => _committing = true);
    // Hold at the commit point while the sheet asks, so the row doesn't
    // snap shut under the question.
    _offset.animateTo(-_kThreshold);

    final bool removed = await widget.onConfirm();
    if (!mounted) return;

    setState(() => _committing = false);
    // On removal the row stays open and the owner's collapse takes over.
    if (!removed) _settle();
  }

  void _settle() {
    _raw = 0;
    _armed = false;
    if (_reduceMotion) {
      _offset.value = 0;
    } else {
      _offset.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (BuildContext context, Widget? child) {
        final double t = (-_offset.value / _kThreshold).clamp(0.0, 1.0);

        return Stack(
          children: [
            Positioned.fill(child: _background(context, t)),
            Transform.translate(
              offset: Offset(_offset.value, 0),
              child: child,
            ),
          ],
        );
      },
      child: GestureDetector(
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: widget.child,
      ),
    );
  }

  Widget _background(BuildContext context, double t) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: ColoredBox(
        color: Color.lerp(cs.surfaceContainer, cs.errorContainer, t)!,
        child: Align(
          alignment: .centerRight,
          child: Padding(
            padding: const .only(right: 24),
            child: Transform.scale(
              scale: 0.5 + 0.5 * t,
              child: Container(
                width: 40,
                height: 40,
                decoration: ShapeDecoration(
                  color: Color.lerp(cs.errorContainer, cs.error, t),
                  shape: ShapeBorder.lerp(_circle, _sunny, t) ?? _circle,
                ),
                child: Icon(
                  Icons.playlist_remove_rounded,
                  size: 22,
                  color: Color.lerp(cs.onErrorContainer, cs.onError, t),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
