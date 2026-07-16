// Gesture plumbing — which ScrollNotifications start and advance a pull — is
// adapted from Flutter's material RefreshIndicator (BSD 3-Clause, see LICENSE).

import 'dart:async';
import 'dart:math' as math;

import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

// The pull distance, after [_kDragMultiplier], at which a release triggers a
// refresh.
const double _kPositionalThreshold = 80.0;

// The furthest the indicator travels, matching the threshold.
const double _kIndicatorMaxDistance = 80.0;

// Raw drag is scaled by this for a rubber-band feel.
const double _kDragMultiplier = 0.5;

// The distance fraction an overshoot is dampened to at most.
const double _kMaxOvershootFraction = 2.0;

// The LoadingIndicator's container size.
const double _kIndicatorSize = 48.0;

const Duration _kCrossfadeDuration = Duration(milliseconds: 200);

// Critically damped: the indicator settles onto the threshold without bounce.
final Motion _settleMotion = SpringMotion(
  SpringDescription.withDampingRatio(mass: 1, stiffness: 1500),
  snapToEnd: true,
);

/// A Material 3 Expressive take on the "swipe to refresh" idiom.
///
/// While you pull, the indicator is *determinate*: it slides down from behind
/// the leading edge and its shape morphs circle -> soft-burst (counter-rotating)
/// as a function of the pull distance, with a dampened overshoot past the
/// threshold. On release past the threshold it springs to the threshold and
/// crossfades to the free-spinning indeterminate morph while [onRefresh] runs,
/// then slides back up.
///
/// Reuses [RefreshCallback], [RefreshIndicatorStatus], and
/// [RefreshIndicatorTriggerMode] from the framework.
class ExpressiveRefreshIndicator extends StatefulWidget {
  /// Creates an expressive refresh indicator.
  const ExpressiveRefreshIndicator({
    super.key,
    this.edgeOffset = 0.0,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.onStatusChange,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    required this.child,
  });

  /// The widget below this widget in the tree.
  ///
  /// The refresh indicator will be stacked on top of this child. The indicator
  /// will appear when child's Scrollable descendant is over-scrolled.
  ///
  /// Typically a [ListView] or [CustomScrollView].
  final Widget child;

  /// The offset from the leading edge where the indicator's travel begins and
  /// where it is clipped, e.g. the status bar / a pinned header height.
  final double edgeOffset;

  /// A function that's called when the user has dragged the refresh indicator
  /// far enough to demonstrate that they want the app to refresh. The
  /// returned [Future] must complete when the refresh operation is finished.
  final RefreshCallback onRefresh;

  /// Called to get the current status of the indicator to update the UI as
  /// needed.
  final ValueChanged<RefreshIndicatorStatus?>? onStatusChange;

  /// The active indicator shape's color. Defaults to the [LoadingIndicator]
  /// contained default, [ColorScheme.onPrimaryContainer].
  final Color? color;

  /// The indicator's container color. Defaults to the [LoadingIndicator]
  /// contained default, [ColorScheme.primaryContainer].
  final Color? backgroundColor;

  /// A check that specifies whether a [ScrollNotification] should be
  /// handled by this widget.
  ///
  /// By default, checks whether `notification.depth == 0`. Set it to
  /// something else for more complicated layouts.
  final ScrollNotificationPredicate notificationPredicate;

  /// The semantic label for the indicator, read aloud by screen readers.
  ///
  /// Defaults to [MaterialLocalizations.refreshIndicatorSemanticLabel].
  final String? semanticsLabel;

  /// Defines how this indicator can be triggered when users overscroll.
  ///
  /// Defaults to [RefreshIndicatorTriggerMode.onEdge].
  final RefreshIndicatorTriggerMode triggerMode;

  @override
  ExpressiveRefreshIndicatorState createState() =>
      ExpressiveRefreshIndicatorState();
}

/// Contains the state for an [ExpressiveRefreshIndicator]. This class can be
/// used to programmatically show the refresh indicator, see the [show]
/// method.
class ExpressiveRefreshIndicatorState extends State<ExpressiveRefreshIndicator>
    with TickerProviderStateMixin<ExpressiveRefreshIndicator> {
  // How far the indicator is out: 0 hidden, 1 at the threshold, up to
  // [_kMaxOvershootFraction] when overscrolled. Set directly while dragging,
  // animated when snapping or hiding.
  late final BoundedSingleMotionController _fraction =
      BoundedSingleMotionController(
        motion: _settleMotion,
        vsync: this,
        lowerBound: 0.0,
        upperBound: _kMaxOvershootFraction,
      );

  RefreshIndicatorStatus? _status;
  late Future<void> _pendingRefreshFuture;
  bool? _isIndicatorAtTop;
  double? _dragOffset;

  @override
  void dispose() {
    _fraction.dispose();
    super.dispose();
  }

  // Linear up to the threshold, then a dampened overshoot topping out at
  // [_kMaxOvershootFraction].
  double _distanceFractionFor(double dragOffset) {
    final double adjusted = dragOffset * _kDragMultiplier;
    final double rawProgress = adjusted / _kPositionalThreshold;
    if (adjusted <= _kPositionalThreshold) {
      return rawProgress;
    }
    final double overshoot = rawProgress.abs() - 1.0;
    final double linearTension = clampDouble(overshoot, 0.0, 2.0);
    final double tensionPercent =
        linearTension - (linearTension * linearTension) / 4.0;
    return 1.0 + tensionPercent;
  }

  bool _shouldStart(ScrollNotification notification) {
    // If the notification.dragDetails is null, this scroll is not triggered
    // by user dragging. It may be a result of ScrollController.jumpTo or
    // ballistic scroll. In this case, we don't want to trigger the refresh
    // indicator.
    return ((notification is ScrollStartNotification &&
                notification.dragDetails != null) ||
            (notification is ScrollUpdateNotification &&
                notification.dragDetails != null &&
                widget.triggerMode == RefreshIndicatorTriggerMode.anywhere)) &&
        ((notification.metrics.axisDirection == AxisDirection.up &&
                notification.metrics.extentAfter == 0.0) ||
            (notification.metrics.axisDirection == AxisDirection.down &&
                notification.metrics.extentBefore == 0.0)) &&
        _status == null &&
        _start(notification.metrics.axisDirection);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) {
      return false;
    }
    if (_shouldStart(notification)) {
      setState(() {
        _status = RefreshIndicatorStatus.drag;
        widget.onStatusChange?.call(_status);
      });
      return false;
    }
    final bool? indicatorAtTopNow =
        switch (notification.metrics.axisDirection) {
          AxisDirection.down || AxisDirection.up => true,
          AxisDirection.left || AxisDirection.right => null,
        };
    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_status == RefreshIndicatorStatus.drag ||
          _status == RefreshIndicatorStatus.armed) {
        _dismiss(RefreshIndicatorStatus.canceled);
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_status == RefreshIndicatorStatus.drag ||
          _status == RefreshIndicatorStatus.armed) {
        if (notification.metrics.axisDirection == AxisDirection.down) {
          _dragOffset = _dragOffset! - notification.scrollDelta!;
        } else if (notification.metrics.axisDirection == AxisDirection.up) {
          _dragOffset = _dragOffset! + notification.scrollDelta!;
        }
        _checkDragOffset();
      }
      if (_status == RefreshIndicatorStatus.armed &&
          notification.dragDetails == null) {
        // On iOS start the refresh when the Scrollable bounces back from the
        // overscroll (ScrollNotification indicating this don't have
        // dragDetails because the scroll activity is not directly triggered
        // by a drag).
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_status == RefreshIndicatorStatus.drag ||
          _status == RefreshIndicatorStatus.armed) {
        if (notification.metrics.axisDirection == AxisDirection.down) {
          _dragOffset = _dragOffset! - notification.overscroll;
        } else if (notification.metrics.axisDirection == AxisDirection.up) {
          _dragOffset = _dragOffset! + notification.overscroll;
        }
        _checkDragOffset();
      }
    } else if (notification is ScrollEndNotification) {
      switch (_status) {
        case RefreshIndicatorStatus.armed:
          if (_fraction.value < 1.0) {
            _dismiss(RefreshIndicatorStatus.canceled);
          } else {
            _show();
          }
        case RefreshIndicatorStatus.drag:
          _dismiss(RefreshIndicatorStatus.canceled);
        case RefreshIndicatorStatus.canceled:
        case RefreshIndicatorStatus.done:
        case RefreshIndicatorStatus.refresh:
        case RefreshIndicatorStatus.snap:
        case null:
          // do nothing
          break;
      }
    }
    return false;
  }

  bool _handleIndicatorNotification(
    OverscrollIndicatorNotification notification,
  ) {
    // TODO(bunpod): this glow suppression only checks depth 0, so on Android
    // a stretch/glow can show alongside the indicator during drag when the
    // scrollable is nested (e.g. NestedScrollView at depth 2); irrelevant on
    // iOS bouncing physics. If it bothers, route widget.notificationPredicate
    // through here too.
    if (notification.depth != 0 || !notification.leading) {
      return false;
    }
    if (_status == RefreshIndicatorStatus.drag) {
      notification.disallowIndicator();
      return true;
    }
    return false;
  }

  bool _start(AxisDirection direction) {
    assert(_status == null);
    assert(_isIndicatorAtTop == null);
    assert(_dragOffset == null);
    switch (direction) {
      case AxisDirection.down:
      case AxisDirection.up:
        _isIndicatorAtTop = true;
      case AxisDirection.left:
      case AxisDirection.right:
        _isIndicatorAtTop = null;
        // we do not support horizontal scroll views.
        return false;
    }
    _dragOffset = 0.0;
    _fraction.value = 0.0;
    return true;
  }

  void _checkDragOffset() {
    assert(
      _status == RefreshIndicatorStatus.drag ||
          _status == RefreshIndicatorStatus.armed,
    );
    double fraction = _distanceFractionFor(math.max(_dragOffset!, 0.0));
    // Once armed, hold at the threshold so a small pull-back doesn't disarm it.
    if (_status == RefreshIndicatorStatus.armed) {
      fraction = math.max(fraction, 1.0);
    }
    _fraction.value = clampDouble(fraction, 0.0, _kMaxOvershootFraction);
    if (_status == RefreshIndicatorStatus.drag && _fraction.value >= 1.0) {
      _status = RefreshIndicatorStatus.armed;
      widget.onStatusChange?.call(_status);
    }
  }

  // Stop showing the refresh indicator.
  Future<void> _dismiss(RefreshIndicatorStatus newMode) async {
    await Future<void>.value();
    // This can only be called from _show() when refreshing and
    // _handleScrollNotification in response to a ScrollEndNotification or
    // direction change.
    assert(
      newMode == RefreshIndicatorStatus.canceled ||
          newMode == RefreshIndicatorStatus.done,
    );
    setState(() {
      _status = newMode;
      widget.onStatusChange?.call(_status);
    });
    await _fraction.animateTo(0.0);
    if (mounted && _status == newMode) {
      _dragOffset = null;
      _isIndicatorAtTop = null;
      setState(() {
        _status = null;
      });
    }
  }

  void _show() {
    assert(_status != RefreshIndicatorStatus.refresh);
    assert(_status != RefreshIndicatorStatus.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    // Flip to refreshing before settling, not after, so the crossfade to the
    // spinner runs while the indicator springs to the threshold.
    setState(() {
      _status = RefreshIndicatorStatus.refresh;
      widget.onStatusChange?.call(_status);
    });
    _fraction.animateTo(1.0);

    final Future<void> refreshResult = widget.onRefresh();
    refreshResult.whenComplete(() {
      if (mounted && _status == RefreshIndicatorStatus.refresh) {
        completer.complete();
        _dismiss(RefreshIndicatorStatus.done);
      }
    });
  }

  /// Show the refresh indicator and run the refresh callback as if it had
  /// been started interactively. If this method is called while the refresh
  /// callback is running, it quietly does nothing.
  ///
  /// Creating the [ExpressiveRefreshIndicator] with a
  /// [GlobalKey<ExpressiveRefreshIndicatorState>] makes it possible to refer
  /// to the [ExpressiveRefreshIndicatorState].
  ///
  /// The future returned from this method completes when the
  /// [ExpressiveRefreshIndicator.onRefresh] callback's future completes.
  ///
  /// If you await the future returned by this function from a [State], you
  /// should check that the state is still [mounted] before calling
  /// [setState].
  ///
  /// When initiated in this manner, the refresh indicator is independent of
  /// any actual scroll view. It defaults to showing the indicator at the top.
  /// To show it at the bottom, set `atTop` to false.
  Future<void> show({bool atTop = true}) {
    if (_status != RefreshIndicatorStatus.refresh &&
        _status != RefreshIndicatorStatus.snap) {
      if (_status == null) {
        _start(atTop ? AxisDirection.down : AxisDirection.up);
      }
      _show();
    }
    return _pendingRefreshFuture;
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleIndicatorNotification,
        child: widget.child,
      ),
    );
    assert(() {
      if (_status == null) {
        assert(_dragOffset == null);
        assert(_isIndicatorAtTop == null);
      } else {
        assert(_dragOffset != null);
        assert(_isIndicatorAtTop != null);
      }
      return true;
    }());

    return Stack(
      children: <Widget>[
        child,
        if (_status != null)
          Positioned(
            top: _isIndicatorAtTop! ? widget.edgeOffset : 0.0,
            bottom: _isIndicatorAtTop! ? 0.0 : widget.edgeOffset,
            left: 0.0,
            right: 0.0,
            // Draw-only: the pull is owned by the scrollable underneath.
            child: IgnorePointer(
              // Clip so the indicator is hidden until it translates into view.
              child: ClipRect(
                child: Align(
                  alignment: _isIndicatorAtTop!
                      ? Alignment.topCenter
                      : Alignment.bottomCenter,
                  child: AnimatedBuilder(
                    animation: _fraction,
                    builder: (BuildContext context, Widget? _) {
                      final double fraction = _fraction.value;
                      final double translate =
                          fraction * _kIndicatorMaxDistance - _kIndicatorSize;
                      return Transform.translate(
                        offset: Offset(
                          0.0,
                          _isIndicatorAtTop! ? translate : -translate,
                        ),
                        child: _buildIndicator(context, fraction),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIndicator(BuildContext context, double fraction) {
    final String label =
        widget.semanticsLabel ??
        MaterialLocalizations.of(context).refreshIndicatorSemanticLabel;
    // Not `done`: on completion it crossfades back to the determinate shape as
    // it slides away.
    final bool refreshing = _status == RefreshIndicatorStatus.refresh;

    return AnimatedSwitcher(
      duration: _kCrossfadeDuration,
      child: refreshing
          ? LoadingIndicator.contained(
              key: const ValueKey<bool>(true),
              activeIndicatorColor: widget.color,
              containerColor: widget.backgroundColor,
              semanticsLabel: label,
            )
          : Transform.rotate(
              key: const ValueKey<bool>(false),
              // Kept on the determinate child so it freezes with it when the
              // crossfade to the spinner begins.
              angle: fraction > 1.0 ? -(fraction - 1.0) * math.pi : 0.0,
              child: LoadingIndicator.containedDeterminate(
                progress: clampDouble(fraction, 0.0, 1.0),
                activeIndicatorColor: widget.color,
                containerColor: widget.backgroundColor,
                semanticsLabel: label,
              ),
            ),
    );
  }
}
