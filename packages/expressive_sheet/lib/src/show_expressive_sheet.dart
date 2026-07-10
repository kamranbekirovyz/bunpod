import 'dart:ui' show SemanticsHitTestBehavior;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

/// Shows a modal sheet anchored to the bottom edge of the screen.
///
/// The sheet enters on an expressive spatial spring and exits on a fast
/// standard spring. Dragging the sheet drives the route animation directly,
/// so the velocity of a released fling is carried into the open or close
/// spring.
///
/// Returns a [Future] that resolves to the value passed to [Navigator.pop]
/// when the sheet is closed.
Future<T?> showExpressiveSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  final MaterialLocalizations localizations = MaterialLocalizations.of(context);

  return Navigator.of(context).push(
    ExpressiveSheetRoute<T>(
      builder: builder,
      barrierLabel: localizations.scrimLabel,
      barrierOnTapHint: localizations.scrimOnTapHint(
        localizations.bottomSheetLabel,
      ),
    ),
  );
}

/// A route that shows a spring-driven modal sheet at the bottom of the
/// screen.
class ExpressiveSheetRoute<T> extends PopupRoute<T> {
  /// Creates a route for a spring-driven modal sheet.
  ExpressiveSheetRoute({
    required this.builder,
    this.barrierLabel,
    this.barrierOnTapHint,
    super.settings,
  });

  /// Builds the content of the sheet.
  final WidgetBuilder builder;

  /// The semantic hint text that informs users what will happen if they tap
  /// on the scrim.
  final String? barrierOnTapHint;

  static const Motion _enter = MaterialSpringMotion.expressiveSpatialDefault();
  static const Motion _exit = MaterialSpringMotion.standardSpatialFast();

  // Resistance applied when dragging past fully open.
  static const double _overdragResistance = 100;

  // Thresholds past which a released drag closes the sheet: fling speed in
  // sheet heights per second, or resting position as a fraction of height.
  static const double _closeVelocity = 0.9;
  static const double _closePosition = 0.5;

  // Release velocity in sheet heights per second (positive is downward),
  // carried from the drag into the close simulation.
  double? _releaseVelocity;

  bool _popped = false;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 350);

  // The scrim fades with the clamped animation so that spring overshoot does
  // not affect its opacity. The slide reads the raw controller and keeps the
  // bounce.
  @override
  Animation<double>? get animation => switch (super.animation) {
    null => null,
    final a => _ClampedAnimation(a),
  };

  @override
  AnimationController createAnimationController() {
    return AnimationController.unbounded(
      duration: transitionDuration,
      reverseDuration: reverseTransitionDuration,
      vsync: navigator!,
    );
  }

  @override
  Simulation? createSimulation({required bool forward}) {
    final double velocity = _releaseVelocity ?? 0;
    _releaseVelocity = null;

    return (forward ? _enter : _exit).createSimulation(
      start: controller?.value ?? 0,
      end: forward ? 1 : 0,
      velocity: -velocity,
    );
  }

  // Same as the default barrier, with the tap hint added so screen readers
  // announce what tapping the scrim does.
  @override
  Widget buildModalBarrier() {
    final Color? scrimColor = barrierColor;
    if (scrimColor != null && scrimColor.a != 0 && !offstage) {
      final Animation<Color?> color = animation!.drive(
        ColorTween(
          begin: scrimColor.withValues(alpha: 0.0),
          end: scrimColor,
        ).chain(CurveTween(curve: barrierCurve)),
      );

      return AnimatedModalBarrier(
        color: color,
        dismissible: barrierDismissible,
        semanticsLabel: barrierLabel,
        barrierSemanticsDismissible: semanticsDismissible,
        semanticsOnTapHint: barrierOnTapHint,
      );
    }

    return ModalBarrier(
      dismissible: barrierDismissible,
      semanticsLabel: barrierLabel,
      barrierSemanticsDismissible: semanticsDismissible,
      semanticsOnTapHint: barrierOnTapHint,
    );
  }

  @override
  bool didPop(T? result) {
    _popped = true;

    return super.didPop(result);
  }

  void _dragBy(double relativeDelta) {
    if (_popped) return;

    final AnimationController controller = this.controller!;

    double delta = relativeDelta;
    if (controller.value > 1) {
      final double overshoot = controller.value - 1;
      delta *= 1 / (1 + overshoot * _overdragResistance);
    }
    controller.value -= delta;
  }

  void _endDrag(double relativeVelocity) {
    if (_popped) return;
    final AnimationController controller = this.controller!;
    final double value = controller.value;

    if (value > 1) {
      // Dragged past fully open. Settle back, damping the velocity by the
      // same resistance that was applied while dragging.
      final double overshoot = value - 1;
      final double damped =
          relativeVelocity / (1 + overshoot * _overdragResistance);
      controller.animateWith(
        _enter.createSimulation(start: value, end: 1, velocity: -damped),
      );

      return;
    }

    final bool close = switch (relativeVelocity) {
      > _closeVelocity => true,
      < -_closeVelocity => false,
      _ => value < _closePosition,
    };

    if (close) {
      _releaseVelocity = relativeVelocity;
      navigator?.pop();
    } else {
      controller.animateWith(
        _enter.createSimulation(
          start: value,
          end: 1,
          velocity: -relativeVelocity,
        ),
      );
    }
  }

  // On iOS and macOS the route announces itself, so no label is needed.
  String _routeLabel(MaterialLocalizations localizations) {
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS || TargetPlatform.macOS => '',
      _ => localizations.dialogLabel,
    };
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final String routeLabel = _routeLabel(MaterialLocalizations.of(context));

    return AnimatedPadding(
      // Keeps the sheet above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: Align(
        alignment: .bottomCenter,
        child: AnimatedBuilder(
          animation: controller!,
          builder: (context, child) {
            return FractionalTranslation(
              translation: Offset(0, 1 - controller!.value),
              child: child,
            );
          },
          child: Semantics(
            scopesRoute: true,
            namesRoute: true,
            label: routeLabel,
            explicitChildNodes: true,
            // Prevents taps inside the sheet from reaching the barrier.
            child: Semantics(
              hitTestBehavior: SemanticsHitTestBehavior.opaque,
              child: Builder(
                builder: (context) {
                  // Drag deltas are normalized by the sheet's own height, so
                  // the gesture and the route animation share one coordinate
                  // space.
                  double height() => context.size?.height ?? 1;

                  return GestureDetector(
                    excludeFromSemantics: true,
                    onVerticalDragUpdate: (details) {
                      _dragBy(details.primaryDelta! / height());
                    },
                    onVerticalDragEnd: (details) {
                      _endDrag(details.velocity.pixelsPerSecond.dy / height());
                    },
                    onVerticalDragCancel: () {
                      _endDrag(0);
                    },
                    child: builder(context),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An animation that forwards [parent] with its value clamped to the range
/// 0.0 to 1.0, for consumers such as the modal barrier that should not see
/// spring overshoot.
class _ClampedAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _ClampedAnimation(this.parent);

  @override
  final Animation<double> parent;

  @override
  double get value => parent.value.clamp(0.0, 1.0);
}
