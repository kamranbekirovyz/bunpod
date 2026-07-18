import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.scheme,
    required this.playing,
    required this.fav,
    required this.onPlayPause,
    required this.onFav,
  });

  final ColorScheme scheme;
  final bool playing;
  final bool fav;
  final VoidCallback onPlayPause;
  final VoidCallback onFav;

  static const double _heroGap = 8;
  static const double _innerGap = 6;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = scheme;
    final Color tonal = cs.surfaceContainerHighest;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Play takes half the width, the 2x2 cluster takes the other half.
        // The cluster is therefore square, so all four cells are equal squares
        // that the buttons fill edge to edge (top: rounded squares, bottom:
        // circles) with no leftover gaps.
        final double heroSide = (constraints.maxWidth - _heroGap) / 2;
        return SizedBox(
          height: heroSide,
          child: Row(
            children: [
              SizedBox(
                width: heroSide,
                height: heroSide,
                child: _PlayButton(
                  playing: playing,
                  color: cs.onSurface,
                  foreground: cs.surface,
                  onTap: onPlayPause,
                ),
              ),
              const SizedBox(width: _heroGap),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _GridButton(
                              color: tonal,
                              rest: MaterialShapes.square,
                              pressed: MaterialShapes.circle,
                              onTap: () {},
                              child: _SeekGlyph(
                                forward: false,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: _innerGap),
                          Expanded(
                            child: _GridButton(
                              color: tonal,
                              rest: MaterialShapes.square,
                              pressed: MaterialShapes.circle,
                              onTap: () {},
                              child: _SeekGlyph(
                                forward: true,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: _innerGap),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: _DownloadButton(scheme: cs)),
                          const SizedBox(width: _innerGap),
                          Expanded(
                            child: _FavButton(
                              fav: fav,
                              scheme: cs,
                              onTap: onFav,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Fills its (square) cell edge to edge. The cell is square so [rest] and
/// [pressed] Material shapes don't distort and morph cleanly between each other
/// on press.
class _GridButton extends StatefulWidget {
  const _GridButton({
    required this.color,
    required this.onTap,
    required this.child,
    required this.rest,
    required this.pressed,
  });

  final Color color;
  final VoidCallback onTap;
  final Widget child;
  final RoundedPolygon rest;
  final RoundedPolygon pressed;

  @override
  State<_GridButton> createState() => _GridButtonState();
}

class _GridButtonState extends State<_GridButton> {
  bool _down = false;

  void _setDown(bool value) {
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.expressiveSpatialFast(),
      value: _down && !reduce ? 1.0 : 0.0,
      builder: (context, t, child) {
        return Transform.scale(
          scale: 1 - 0.05 * t,
          child: ClipPath(
            clipper: ShapeBorderClipper(shape: _shapeAt(t)),
            child: child,
          ),
        );
      },
      child: Material(
        color: widget.color,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => _setDown(true),
          onTapUp: (_) => _setDown(false),
          onTapCancel: () => _setDown(false),
          child: SizedBox.expand(child: Center(child: widget.child)),
        ),
      ),
    );
  }

  ShapeBorder _shapeAt(double t) {
    final MaterialShapeBorder rest = MaterialShapeBorder(shape: widget.rest);
    if (t <= 0) return rest;
    final MaterialShapeBorder pressed = MaterialShapeBorder(
      shape: widget.pressed,
    );
    if (t >= 1) return pressed;
    return rest.lerpTo(pressed, t)!;
  }
}

enum _DownloadState { idle, downloading, done }

/// Download with a flourish: tap morphs the circle into a [bun] (the app's
/// shape) and fills it with [primary] over 5s (determinate progress → linear),
/// then on completion morphs into a [sunny] with a check. Tap again to reset.
class _DownloadButton extends StatefulWidget {
  const _DownloadButton({required this.scheme});

  final ColorScheme scheme;

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fill = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );

  _DownloadState _state = _DownloadState.idle;
  bool _down = false;

  @override
  void initState() {
    super.initState();
    _fill.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _state = _DownloadState.done);
      }
    });
  }

  @override
  void dispose() {
    _fill.dispose();
    super.dispose();
  }

  void _onTap() {
    switch (_state) {
      case _DownloadState.idle:
        setState(() => _state = _DownloadState.downloading);
        _fill.forward(from: 0);
      case _DownloadState.downloading:
        break;
      case _DownloadState.done:
        setState(() {
          _state = _DownloadState.idle;
          _fill.value = 0;
        });
    }
  }

  void _setDown(bool value) {
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = widget.scheme;
    final bool reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final bool done = _state == _DownloadState.done;
    final Color accent = cs.primary;
    final IconData icon = done
        ? Icons.check_rounded
        : Icons.download_for_offline_outlined;

    return AnimatedScale(
      scale: _down && !reduce ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: SingleMotionBuilder(
        // Low-overshoot spring so the mid-stop (downloading shape) lands cleanly
        // instead of bouncing across into the done shape.
        motion: const MaterialSpringMotion.standardSpatialFast(),
        value: switch (_state) {
          _DownloadState.idle => 0.0,
          _DownloadState.downloading => 0.5,
          _DownloadState.done => 1.0,
        },
        builder: (context, t, child) => ClipPath(
          clipper: ShapeBorderClipper(shape: _shapeAt(t)),
          child: child,
        ),
        child: AnimatedBuilder(
          animation: _fill,
          builder: (context, _) {
            final double f = _fill.value;
            return Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(color: cs.surfaceContainerHighest),
                ),
                Positioned.fill(
                  child: Center(
                    child: Icon(icon, color: cs.onSurface, size: 26),
                  ),
                ),
                Positioned.fill(
                  child: ClipRect(
                    clipper: _BottomFillClipper(f),
                    child: Stack(
                      children: [
                        Positioned.fill(child: ColoredBox(color: accent)),
                        Positioned.fill(
                          child: Center(
                            child: Icon(icon, color: cs.onPrimary, size: 26),
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
                      onTapDown: (_) => _setDown(true),
                      onTapUp: (_) => _setDown(false),
                      onTapCancel: () => _setDown(false),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // circle (idle) → bun (downloading, t=0.5) → sunny (done, t=1).
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
  bool shouldReclip(_BottomFillClipper oldClipper) =>
      oldClipper.fraction != fraction;
}

/// Favorite toggle. Idle it's a tonal circle matching the other buttons; when
/// faved it blooms into a filled tertiary gem shape (a distinct accent from the
/// primary used by the title/hero) with an onTertiary heart.
class _FavButton extends StatefulWidget {
  const _FavButton({
    required this.fav,
    required this.scheme,
    required this.onTap,
  });

  final bool fav;
  final ColorScheme scheme;
  final VoidCallback onTap;

  @override
  State<_FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<_FavButton> {
  bool _down = false;

  void _setDown(bool value) {
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = widget.scheme;
    final bool reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return AnimatedScale(
      scale: _down && !reduce ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: SingleMotionBuilder(
        motion: const MaterialSpringMotion.expressiveSpatialFast(),
        value: widget.fav ? 1.0 : 0.0,
        builder: (context, t, child) {
          final Color bg = Color.lerp(
            cs.surfaceContainerHighest,
            cs.tertiary,
            t,
          )!;
          return ClipPath(
            clipper: ShapeBorderClipper(shape: _shapeAt(t)),
            child: Material(color: bg, child: child),
          );
        },
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => _setDown(true),
          onTapUp: (_) => _setDown(false),
          onTapCancel: () => _setDown(false),
          child: SizedBox.expand(
            child: Center(
              child: Icon(
                widget.fav
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: widget.fav ? cs.onTertiary : cs.onSurface,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ShapeBorder _shapeAt(double t) {
    final MaterialShapeBorder circle = MaterialShapeBorder(
      shape: MaterialShapes.circle,
    );
    if (t <= 0) return circle;
    final MaterialShapeBorder bloom = MaterialShapeBorder(
      shape: MaterialShapes.gem,
    );
    if (t >= 1) return bloom;
    return circle.lerpTo(bloom, t)!;
  }
}

class _SeekGlyph extends StatelessWidget {
  const _SeekGlyph({required this.forward, required this.color});

  final bool forward;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.flip(
          flipX: forward,
          child: Icon(Icons.replay_rounded, color: color, size: 34),
        ),
        Text(
          '15',
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ],
    );
  }
}

/// Hero play/pause. Its Material shape reflects playback state: a square when
/// paused, morphing to a circle while playing.
class _PlayButton extends StatefulWidget {
  const _PlayButton({
    required this.playing,
    required this.color,
    required this.foreground,
    required this.onTap,
  });

  final bool playing;
  final Color color;
  final Color foreground;
  final VoidCallback onTap;

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
  bool _down = false;

  void _setDown(bool value) {
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return AnimatedScale(
      scale: _down && !reduce ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: SingleMotionBuilder(
        // Big hero element → slow spatial spring (fast=small, default=medium,
        // slow=large), with expressive bounce for the play/pause hero moment.
        motion: const MaterialSpringMotion.expressiveSpatialSlow(),
        value: widget.playing ? 1.0 : 0.0,
        builder: (context, t, child) => ClipPath(
          clipper: ShapeBorderClipper(shape: _shapeAt(t)),
          child: child,
        ),
        child: Material(
          color: widget.color,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => _setDown(true),
            onTapUp: (_) => _setDown(false),
            onTapCancel: () => _setDown(false),
            child: SizedBox.expand(
              child: Center(
                child: Icon(
                  widget.playing
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: widget.foreground,
                  size: 52,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ShapeBorder _shapeAt(double t) {
    final MaterialShapeBorder square = MaterialShapeBorder(
      shape: MaterialShapes.square,
    );
    if (t <= 0) return square;
    final MaterialShapeBorder circle = MaterialShapeBorder(
      shape: MaterialShapes.circle,
    );
    if (t >= 1) return circle;
    return square.lerpTo(circle, t)!;
  }
}
