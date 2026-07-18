import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:material_wavy_progress_indicator/material_wavy_progress_indicator.dart';

class HomePlayerCard extends StatelessWidget {
  const HomePlayerCard({
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
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: .circular(36),
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
                  shape: MaterialShapeBorder(
                    shape: MaterialShapes.sunny,
                  ),
                ),
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: ColoredBox(
                    color: cs.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const .all(24),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: [
                Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        ClipPath(
                          clipper: ShapeBorderClipper(
                            shape: MaterialShapeBorder(
                              shape: coverShape,
                            ),
                          ),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: _Cover(
                              imageUrl: imageUrl,
                              scheme: cs,
                            ),
                          ),
                        ),
                        8.gap,
                        Text(
                          channel.toUpperCase(),
                          style: tt.labelSmall?.copyWith(
                            color: cs.onPrimary.withValues(alpha: 0.85),
                            fontWeight: .w700,
                          ),
                        ),
                      ],
                    ),
                    4.gap,
                    Text(
                      title,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: tt.headlineSmall?.copyWith(
                        color: cs.onPrimary,
                        fontWeight: .w800,
                      ),
                    ),
                  ],
                ),
                16.gap,
                Row(
                  crossAxisAlignment: .center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          WavyLinearProgressIndicator(
                            value: clampedProgress,
                            color: cs.onPrimary,
                            trackColor: cs.onPrimary.withValues(alpha: 0.25),
                            stopIndicatorColor: cs.onPrimary,
                          ),
                          8.gap,
                          Text(
                            '${timeLeft.remainingLabel} left',
                            style: tt.labelMedium?.copyWith(
                              color: cs.onPrimary.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.gap,
                    Material(
                      color: cs.onPrimary,
                      shape: MaterialShapeBorder(
                        shape: _heroButtonShapes[_kHeroButtonShape],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: onPlayPause,
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: Icon(
                            Icons.pause_rounded,
                            color: cs.primary,
                            size: 32,
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
  const _Cover({
    required this.imageUrl,
    required this.scheme,
  });

  final String imageUrl;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return SmoothImage(
      url: imageUrl,
      placeholderColor: scheme.primaryContainer,
      placeholderChild: Icon(
        Icons.podcasts_rounded,
        color: scheme.onPrimaryContainer,
      ),
      errorChild: Icon(
        Icons.podcasts_rounded,
        color: scheme.onPrimaryContainer,
      ),
    );
  }
}
