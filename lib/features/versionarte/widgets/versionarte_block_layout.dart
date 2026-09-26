import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

/// The skeleton both blocking screens are built on: an opaque full-screen
/// surface that swallows taps and reveals its contents in three staggered
/// spring stages — badge, then words, then action.
///
/// It is deliberately only a skeleton. Colour, shape and copy come from the
/// screen using it, which is what lets maintenance read as muted and a forced
/// update read as urgent while the choreography stays the same.
class VersionarteBlockLayout extends StatefulWidget {
  const VersionarteBlockLayout({
    super.key,
    required this.background,
    this.badge,
    required this.title,
    required this.body,
    required this.titleStyle,
    required this.bodyStyle,
    this.eyebrow,
    this.backdrop,
    this.actions = const <Widget>[],
  });

  final Color background;

  /// Optional. A screen that already has a backdrop carrying it does not need
  /// a shape in the middle repeating the point.
  final Widget? badge;

  /// Painted edge to edge behind everything, under the status bar and the home
  /// indicator, and never hit-testable. Where a screen goes to get depth.
  final Widget? backdrop;
  final String title;
  final String body;
  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  /// Small line above the title — a version chip, a status word.
  final Widget? eyebrow;

  final List<Widget> actions;

  @override
  State<VersionarteBlockLayout> createState() => _VersionarteBlockLayoutState();
}

class _VersionarteBlockLayoutState extends State<VersionarteBlockLayout> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();

    // One frame at rest, then the spring runs. Starting from a settled frame
    // is what makes the entry read as an arrival rather than a jump cut.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _shown = true);
    });
  }

  /// Slices one spring value into a later, still-springy sub-stage. The spring
  /// overshoots past 1, which the clamp absorbs.
  static double _stage(double t, double start) {
    return ((t - start) / (1 - start)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return Material(
      color: widget.background,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (widget.backdrop != null)
            // Outside the SafeArea on purpose: the shapes are supposed to run
            // off the edges rather than stop at the inset.
            Positioned.fill(
              child: IgnorePointer(
                child: ClipRect(child: widget.backdrop),
              ),
            ),
          SingleMotionBuilder(
            motion: const MaterialSpringMotion.expressiveSpatialDefault(),
            value: _shown ? 1.0 : 0.0,
            active: !reduceMotion,
            builder: (BuildContext context, double t, Widget? child) {
              final double badgeStage = _stage(t, 0.0);
              final double textStage = _stage(t, 0.12);
              final double actionStage = _stage(t, 0.28);

              return Padding(
                padding: const .symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Centred while it fits, scrollable once it doesn't —
                    // which is what a long maintenance message or a large
                    // text scale turns this into.
                    Expanded(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Spacer(),
                            // Sharing the text's left edge: one axis down
                            // the screen, badge to chip to title to button.
                            if (widget.badge != null) ...<Widget>[
                              _Reveal(
                                t: badgeStage,
                                offset: 0,
                                scaleFrom: 0.72,
                                alignment: Alignment.centerLeft,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: widget.badge,
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                            _Reveal(
                              t: textStage,
                              offset: 28,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (widget.eyebrow != null) ...<Widget>[
                                    widget.eyebrow!,
                                    const SizedBox(height: 14),
                                  ],
                                  Text(
                                    widget.title,
                                    style: widget.titleStyle,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.body,
                                    style: widget.bodyStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.actions.isNotEmpty) ...<Widget>[
                      120.gap,
                      _Reveal(
                        t: actionStage,
                        offset: 36,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: widget.actions,
                        ),
                      ),
                      const BottomPadding(),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Fade plus rise, optionally with a scale, driven by an already-staged value.
class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.t,
    required this.offset,
    required this.child,
    this.scaleFrom = 1.0,
    this.alignment = Alignment.center,
  });

  final double t;
  final double offset;
  final double scaleFrom;

  /// Where the scale grows from. Left, so a left-aligned badge stays pinned to
  /// its edge instead of sliding in from the middle.
  final Alignment alignment;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, (1 - t) * offset),
        child: Transform.scale(
          scale: scaleFrom + (1 - scaleFrom) * t,
          alignment: alignment,
          child: child,
        ),
      ),
    );
  }
}
