import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

/// Two-beat removal for a row in a list. Beat one: the row implodes in place
/// — shrinks and fades inside its slot, leaving a hole in the list. Beat two:
/// the hole snaps shut on an expressive spatial spring. The spring overshoots
/// past closed (clamped — that's the neighbors hitting), rebounds a few pixels
/// open, and settles: the rows visibly collide and bounce apart.
///
/// [onRemoved] fires once the slot has settled shut; the owner removes the row
/// from its data there, so the list never jumps. Keep the row keyed, or a
/// mid-removal row loses its animation state when rows above it leave.
class RemovalCollapse extends StatefulWidget {
  const RemovalCollapse({
    super.key,
    required this.removing,
    required this.onRemoved,
    required this.child,
  });

  /// When flipped to true, the row plays its removal and calls [onRemoved]
  /// once its slot has fully closed.
  final bool removing;
  final VoidCallback? onRemoved;
  final Widget child;

  @override
  State<RemovalCollapse> createState() => _RemovalCollapseState();
}

class _RemovalCollapseState extends State<RemovalCollapse> {
  bool _collapsing = false;

  @override
  Widget build(BuildContext context) {
    return SingleMotionBuilder(
      value: _collapsing ? 0 : 1,
      // Default spatial speed: the slot closing moves the rest of the list,
      // not just one small element.
      motion: const MaterialSpringMotion.expressiveSpatialDefault(),
      onAnimationStatusChanged: (status) {
        if (status == .completed && _collapsing) {
          widget.onRemoved?.call();
        }
      },
      builder: (context, slot, child) {
        return ClipRect(
          child: Align(
            alignment: .center,
            // Raw spring value: below zero the slot is simply shut (impact),
            // the rebound above zero briefly reopens it (bounce apart).
            heightFactor: slot < 0 ? 0.0 : slot,
            child: child,
          ),
        );
      },
      child: SingleMotionBuilder(
        value: widget.removing ? 0 : 1,
        motion: const MaterialSpringMotion.standardSpatialFast(),
        onAnimationStatusChanged: (status) {
          if (status == .completed && widget.removing && !_collapsing) {
            setState(() => _collapsing = true);
          }
        },
        builder: (context, pop, child) {
          final double t = pop.clamp(0.0, 1.0);

          return Opacity(
            opacity: t,
            child: Transform.scale(
              scale: t,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
