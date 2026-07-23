import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

enum _DownloadState { idle, downloading, done }

/// Tap morphs circle → bun and fills with primary over 5s, then → sunny with a
/// check. Tap again to reset. While pressed it previews the next shape.
class DownloadButton extends StatefulWidget {
  const DownloadButton({
    super.key,
    required this.scheme,
  });

  final ColorScheme scheme;

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  _DownloadState _state = _DownloadState.idle;
  bool _down = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animationController.addStatusListener((status) {
      if (status == .completed) {
        setState(() {
          _state = .done;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    switch (_state) {
      case _DownloadState.idle:
        setState(() {
          _state = _DownloadState.downloading;
        });
        _animationController.forward(from: 0);

      case _DownloadState.downloading:
        break;

      case _DownloadState.done:
        setState(() {
          _state = _DownloadState.idle;
          _animationController.value = 0;
        });
    }
  }

  void _setDown(bool value) {
    if (_down != value) {
      setState(() {
        _down = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = widget.scheme;
    final bool reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final bool done = _state == .done;
    final Color accent = cs.primary;
    final IconData icon = done
        ? Icons.check_rounded
        : Icons.download_for_offline_outlined;

    return SingleMotionBuilder(
      // Low overshoot so the mid-stop (bun) doesn't bounce past into sunny.
      motion: const MaterialSpringMotion.standardSpatialFast(),
      value: (_down && !reduce)
          ? switch (_state) {
              .idle => 0.5,
              .downloading => 0.5,
              .done => 0.0,
            }
          : switch (_state) {
              .idle => 0.0,
              .downloading => 0.5,
              .done => 1.0,
            },
      builder: (context, t, child) {
        return ClipPath(
          clipper: ShapeBorderClipper(
            shape: _shapeAt(t),
          ),
          child: child,
        );
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          final double f = _animationController.value;

          return Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(
                  color: cs.surfaceContainerHighest,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Icon(
                    icon,
                    color: cs.onSurface,
                  ),
                ),
              ),
              Positioned.fill(
                child: ClipRect(
                  clipper: _BottomFillClipper(f),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ColoredBox(
                          color: accent,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Icon(
                            icon,
                            color: cs.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _onTap,
                    onTapDown: (_) {
                      _setDown(true);
                    },
                    onTapUp: (_) {
                      _setDown(false);
                    },
                    onTapCancel: () {
                      _setDown(false);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // circle (idle) → bun (t=0.5) → sunny (t=1).
  ShapeBorder _shapeAt(double t) {
    final MaterialShapeBorder circle = MaterialShapeBorder(
      shape: MaterialShapes.circle,
    );
    final MaterialShapeBorder downloading = MaterialShapeBorder(
      shape: MaterialShapes.bun,
    );

    if (t <= 0) return circle;
    if (t <= 0.5) {
      final double p = t / 0.5;
      return p >= 1 ? downloading : circle.lerpTo(downloading, p)!;
    }

    final MaterialShapeBorder done = MaterialShapeBorder(
      shape: MaterialShapes.sunny,
    );
    final double p = (t - 0.5) / 0.5;

    return p >= 1 ? done : downloading.lerpTo(done, p)!;
  }
}

class _BottomFillClipper extends CustomClipper<Rect> {
  const _BottomFillClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(
    0,
    size.height * (1 - fraction),
    size.width,
    size.height * fraction,
  );

  @override
  bool shouldReclip(_BottomFillClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}
