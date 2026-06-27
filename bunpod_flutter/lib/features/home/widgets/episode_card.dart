import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

class EpisodeCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              clipper: _FillClipper(start: _kFillStart, fraction: progress),
              child: ColoredBox(color: fill),
            ),
          ),
          _content(context, cs, cs.onSurface),
          Positioned.fill(
            child: ClipRect(
              clipper: _FillClipper(start: _kFillStart, fraction: progress),
              child: _content(context, cs, onFill),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trailing(BuildContext context, Color fg) {
    if (episode.progress >= 1.0) {
      return Icon(Icons.check_circle_rounded, size: 20, color: fg);
    }
    return const SizedBox.shrink();
  }

  Widget _content(BuildContext context, ColorScheme cs, Color fg) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SingleMotionBuilder(
            motion: const MaterialSpringMotion.standardSpatialFast(),
            value: playing ? 1.0 : 0.0,
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
                Text(
                  episode.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleMedium?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _trailing(context, fg),
        ],
      ),
    );
  }
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
