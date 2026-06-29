import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

class EpisodeCard extends StatefulWidget {
  const EpisodeCard({
    super.key,
    required this.episode,
    required this.playing,
    required this.onTap,
  });

  final Episode episode;
  final bool playing;
  final VoidCallback onTap;

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard>
    with SingleTickerProviderStateMixin {
  static const Duration _marqueeCycle = Duration(seconds: 20);

  late final AnimationController _marquee = AnimationController(
    vsync: this,
    duration: _marqueeCycle,
  );

  @override
  void initState() {
    super.initState();
    if (widget.playing) _marquee.repeat();
  }

  @override
  void didUpdateWidget(EpisodeCard old) {
    super.didUpdateWidget(old);
    if (widget.playing && !_marquee.isAnimating) {
      _marquee.repeat();
    } else if (!widget.playing && _marquee.isAnimating) {
      _marquee.stop();
      _marquee.value = 0;
    }
  }

  @override
  void dispose() {
    _marquee.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Episode episode = widget.episode;
    final bool playing = widget.playing;
    final ColorScheme cs = episode.scheme(context);
    final double progress = episode.progress;

    final Color fill = cs.primary;
    final Color onFill = cs.onPrimary;

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.standardSpatialFast(),
      value: playing ? 1.0 : 0.0,
      builder: (context, t, child) {
        final double radius = 24 + (40 - 24) * t;
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(radius < 0 ? 0 : radius),
          ),
          child: child,
        );
      },
      child: AnimatedBuilder(
        animation: _marquee,
        builder: (context, _) {
          final double marqueeTime =
              _marquee.value * _marqueeCycle.inMilliseconds / 1000;

          return Stack(
            children: [
              Positioned.fill(
                child: ClipRect(
                  clipper: _FillClipper(start: _kFillStart, fraction: progress),
                  child: ColoredBox(color: fill),
                ),
              ),
              _content(context, cs, cs.onSurface, marqueeTime),
              Positioned.fill(
                child: ClipRect(
                  clipper: _FillClipper(start: _kFillStart, fraction: progress),
                  child: _content(context, cs, onFill, marqueeTime),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: widget.onTap),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _trailing(BuildContext context, ColorScheme cs, Color fg) {
    final Episode episode = widget.episode;

    if (episode.progress >= 1.0) {
      return Container(
        width: 30,
        height: 30,
        decoration: ShapeDecoration(
          color: fg,
          shape: MaterialShapeBorder(
            shape: MaterialShapes.cookie7Sided,
          ),
        ),
        child: Icon(
          Icons.check_rounded,
          size: 18,
          color: cs.primary,
        ),
      );
    }

    final bool started = episode.listened > Duration.zero;
    final Duration remaining = episode.total - episode.listened;

    return Text(
      started ? '-${remaining.remainingLabel}' : remaining.remainingLabel,
      style: GoogleFonts.unbounded(
        color: fg,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }

  Widget _content(
    BuildContext context,
    ColorScheme cs,
    Color fg,
    double marqueeTime,
  ) {
    final Episode episode = widget.episode;
    final TextTheme tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SingleMotionBuilder(
            motion: const MaterialSpringMotion.standardSpatialFast(),
            value: widget.playing ? 1.0 : 0.0,
            builder: (context, t, child) => ClipPath(
              clipper: ShapeBorderClipper(shape: ShapeValues.coverBorder(t)),
              child: child,
            ),
            child: SizedBox(
              width: 56,
              height: 56,
              child: _Cover(episode: episode, scheme: cs),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  episode.channel.toUpperCase(),
                  style: tt.labelSmall?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                _Title(
                  text: episode.title,
                  style: tt.titleMedium?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w700,
                  ),
                  playing: widget.playing,
                  marqueeTime: marqueeTime,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _trailing(context, cs, fg),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.text,
    required this.style,
    required this.playing,
    required this.marqueeTime,
  });

  final String text;
  final TextStyle? style;
  final bool playing;
  final double marqueeTime;

  static const double _speed = 45;
  static const double _minTravel = 1.4;
  static const double _maxTravel = 6.0;
  static const double _holdStart = 2.0;
  static const double _holdEnd = 1.5;
  static const double _fadePx = 22;

  static final SpringSimulation _spring = SpringSimulation(
    const MaterialSpringMotion.standardSpatialSlow().description,
    0,
    1,
    0,
  );
  static final double _settle = _settleTime();

  static double _settleTime() {
    double t = 0;
    while (!_spring.isDone(t) && t < 4) {
      t += 1 / 240;
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final TextPainter tp = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();
        final double overflow = tp.width - maxWidth;

        if (overflow <= 0.5) {
          return Text(
            text,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.clip,
            style: style,
          );
        }

        final double offset = playing ? _offset(overflow) : 0;
        final double frac = (_fadePx / maxWidth).clamp(0.0, 0.45);
        final double leftFade = (offset / _fadePx).clamp(0.0, 1.0);
        final double rightFade = ((overflow - offset) / _fadePx).clamp(
          0.0,
          1.0,
        );

        final Widget scrolling = SizedBox(
          width: maxWidth,
          height: tp.height,
          child: ClipRect(
            child: OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: Offset(-offset, 0),
                child: Text(text, maxLines: 1, softWrap: false, style: style),
              ),
            ),
          ),
        );

        return ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (Rect bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromRGBO(0, 0, 0, 1 - leftFade),
              const Color(0xFF000000),
              const Color(0xFF000000),
              Color.fromRGBO(0, 0, 0, 1 - rightFade),
            ],
            stops: [0.0, frac, 1 - frac, 1.0],
          ).createShader(bounds),
          child: scrolling,
        );
      },
    );
  }

  double _offset(double overflow) {
    final double travel = (overflow / _speed).clamp(_minTravel, _maxTravel);
    final double t = marqueeTime;
    if (t < _holdStart) return 0;
    if (t < _holdStart + travel) {
      return _curve((t - _holdStart) / travel) * overflow;
    }
    if (t < _holdStart + travel + _holdEnd) return overflow;
    if (t < _holdStart + 2 * travel + _holdEnd) {
      final double p = (t - _holdStart - travel - _holdEnd) / travel;
      return (1 - _curve(p)) * overflow;
    }
    return 0;
  }

  double _curve(double p) => _spring.x(p * _settle).clamp(0.0, 1.0);
}

const double _kFillStart = 0;

class _FillClipper extends CustomClipper<Rect> {
  const _FillClipper({required this.start, required this.fraction});
  final double start;
  final double fraction;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(
    start,
    0,
    (size.width - start) * fraction,
    size.height,
  );

  @override
  bool shouldReclip(_FillClipper oldClipper) =>
      oldClipper.start != start || oldClipper.fraction != fraction;
}

class _Cover extends StatelessWidget {
  const _Cover({required this.episode, required this.scheme});
  final Episode episode;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    Widget placeholder() => Container(
      color: scheme.primaryContainer,
      alignment: Alignment.center,
      child: Icon(Icons.podcasts_rounded, color: scheme.onPrimaryContainer),
    );
    return Image.network(
      episode.image,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : placeholder(),
      errorBuilder: (context, error, stack) => placeholder(),
    );
  }
}
