import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:material_wavy_progress_indicator/material_wavy_progress_indicator.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    required this.scheme,
    required this.imageUrl,
    required this.channel,
    required this.title,
    required this.progress,
    required this.timeLeft,
    required this.coverShape,
    this.onPlayPause,
  });

  final ColorScheme scheme;
  final String imageUrl;
  final String channel;
  final String title;
  final double progress;
  final Duration timeLeft;
  final RoundedPolygon coverShape;
  final VoidCallback? onPlayPause;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = scheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final double clampedProgress = progress.clamp(0.0, 1.0);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -44,
            right: -44,
            child: Opacity(
              opacity: 0.12,
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: MaterialShapeBorder(shape: MaterialShapes.sunny),
                ),
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: ColoredBox(color: cs.onPrimary),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: MaterialShapeBorder(shape: coverShape),
                      ),
                      child: SizedBox(
                        width: 96,
                        height: 96,
                        child: _Cover(imageUrl: imageUrl, scheme: cs),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            channel.toUpperCase(),
                            style: tt.labelSmall?.copyWith(
                              color: cs.onPrimary.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: tt.headlineSmall?.copyWith(
                              color: cs.onPrimary,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WavyLinearProgressIndicator(
                            value: clampedProgress,
                            color: cs.onPrimary,
                            trackColor: cs.onPrimary.withValues(alpha: 0.25),
                            stopIndicatorColor: cs.onPrimary,
                          ),
                          const SizedBox(height: 9),
                          Text(
                            _formatLeft(timeLeft),
                            style: tt.labelMedium?.copyWith(
                              color: cs.onPrimary.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Material(
                      color: cs.onPrimary,
                      shape: MaterialShapeBorder(
                        shape: _heroButtonShapes[_kHeroButtonShape],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: onPlayPause,
                        child: SizedBox(
                          width: 62,
                          height: 62,
                          child: Icon(
                            Icons.pause_rounded,
                            color: cs.primary,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatLeft(Duration d) {
  final int h = d.inHours;
  final int m = d.inMinutes.remainder(60);
  return h > 0 ? '${h}h ${m}m left' : '${m}m left';
}

final List<RoundedPolygon> _heroButtonShapes = <RoundedPolygon>[
  MaterialShapes.cookie7Sided,
  MaterialShapes.clover4Leaf,
  MaterialShapes.pentagon,
  MaterialShapes.gem,
  MaterialShapes.puffy,
  MaterialShapes.sunny,
  MaterialShapes.flower,
];
const int _kHeroButtonShape = 0;

class _Cover extends StatelessWidget {
  const _Cover({required this.imageUrl, required this.scheme});
  final String imageUrl;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return SmoothImage(
      url: imageUrl,
      placeholderColor: scheme.primaryContainer,
      placeholderChild:
          Icon(Icons.podcasts_rounded, color: scheme.onPrimaryContainer),
      errorChild:
          Icon(Icons.podcasts_rounded, color: scheme.onPrimaryContainer),
    );
  }
}
