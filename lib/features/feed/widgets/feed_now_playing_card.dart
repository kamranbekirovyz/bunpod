import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart' hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_wavy_progress_indicator/material_wavy_progress_indicator.dart';
import 'package:motor/motor.dart';

class FeedNowPlayingCard extends StatelessWidget {
  const FeedNowPlayingCard({
    super.key,
    required this.episode,
  });

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = episode.scheme(context);
    final TextTheme tt = Theme.of(context).textTheme;
    final double progress = episode.progress.clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => _openPlayer(context),
      behavior: .translucent,
      child: Container(
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
                                shape: ShapeValues.coverFocused,
                              ),
                            ),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: _Cover(
                                imageUrl: episode.cover,
                                scheme: cs,
                              ),
                            ),
                          ),
                          8.gap,
                          Text(
                            (episode.channel?.title ?? '').toUpperCase(),
                            style: tt.labelSmall?.copyWith(
                              color: cs.onPrimary.withValues(alpha: 0.85),
                              fontWeight: .w700,
                            ),
                          ),
                        ],
                      ),
                      4.gap,
                      Text(
                        episode.title ?? '',
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
                              value: progress,
                              color: cs.onPrimary,
                              trackColor: cs.onPrimary.withValues(alpha: 0.25),
                              stopIndicatorColor: cs.onPrimary,
                            ),
                            8.gap,
                            Text(
                              episode.played
                                  ? 'Played'
                                  : '${episode.remaining.remainingLabel} left',
                              style: tt.labelMedium?.copyWith(
                                color: cs.onPrimary.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      16.gap,
                      _PlayButton(episode: episode, scheme: cs),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPlayer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) {
          return PlayerPage(episode: episode);
        },
      ),
    );
  }
}

/// Plays or pauses [episode]. Only this button listens to the player, so a
/// play/pause change doesn't rebuild the whole card.
class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.episode,
    required this.scheme,
  });

  final Episode episode;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final PlayerCubit player = locator<PlayerCubit>();

    return BlocSelector<PlayerCubit, Playback, (bool, bool, bool)>(
      bloc: player,
      selector: (playback) {
        final bool current = playback.episode?.id == episode.id;

        return (
          current,
          current && playback.playing,
          current && playback.loading,
        );
      },
      builder: (context, state) {
        final (bool current, bool playing, bool loading) = state;

        return SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialFast(),
          value: playing ? 1.0 : 0.0,
          active: !MediaQuery.disableAnimationsOf(context),
          builder: (context, t, child) {
            return ClipPath(
              clipper: ShapeBorderClipper(
                shape: _paused.lerpTo(_playing, t.clamp(0.0, 1.0))!,
              ),
              child: child,
            );
          },
          child: Material(
            color: scheme.onPrimary,
            child: InkWell(
              onTap: () => current ? player.toggle() : player.play(episode),
              child: SizedBox(
                width: 64,
                height: 64,
                child: Stack(
                  alignment: .center,
                  children: [
                    AnimatedOpacity(
                      opacity: loading ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: LoadingIndicator(
                        activeIndicatorColor: scheme.primary,
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: loading ? 0 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: scheme.primary,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

final MaterialShapeBorder _paused = MaterialShapeBorder(
  shape: MaterialShapes.cookie7Sided,
);
final MaterialShapeBorder _playing = MaterialShapeBorder(
  shape: MaterialShapes.sunny,
);

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
