import 'dart:ui' show lerpDouble;

import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_wavy_progress_indicator/material_wavy_progress_indicator.dart';
import 'package:motor/motor.dart';

/// Shrinks from the full card into a pill as [collapse] goes from 0 to 1.
class FeedNowPlayingCard extends StatelessWidget {
  const FeedNowPlayingCard({
    super.key,
    required this.episode,
    this.collapse = 0,
  });

  final Episode episode;
  final double collapse;

  static const double expandedHeight = 220;
  static const double _collapsedHeight = 64;

  void _openPlayer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) {
          return PlayerPage(episode: episode);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = episode.scheme(context);
    final double full = (1 - collapse * 2).clamp(0.0, 1.0);
    final double mini = (collapse * 2 - 1).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => _openPlayer(context),
      behavior: .translucent,
      child: Container(
        clipBehavior: .antiAlias,
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: .circular(
            lerpDouble(36, _collapsedHeight / 2, collapse)!,
          ),
        ),
        child: SizedBox(
          height: lerpDouble(expandedHeight, _collapsedHeight, collapse),
          child: OverflowBox(
            alignment: .topCenter,
            minHeight: expandedHeight,
            maxHeight: expandedHeight,
            child: Stack(
              children: [
                Positioned(
                  top: -44,
                  right: -44,
                  child: Opacity(
                    opacity: 0.12 * full,
                    child: _Blob(color: cs.onPrimary),
                  ),
                ),
                _FadeIn(
                  opacity: full,
                  child: _FullContent(episode: episode, scheme: cs),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: _collapsedHeight,
                  child: _FadeIn(
                    opacity: mini,
                    child: _MiniContent(episode: episode, scheme: cs),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FadeIn extends StatelessWidget {
  const _FadeIn({required this.opacity, required this.child});

  final double opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: opacity == 0,
      child: Opacity(
        opacity: opacity,
        child: child,
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: MaterialShapeBorder(shape: MaterialShapes.sunny),
      ),
      child: SizedBox(
        width: 180,
        height: 180,
        child: ColoredBox(color: color),
      ),
    );
  }
}

class _FullContent extends StatelessWidget {
  const _FullContent({required this.episode, required this.scheme});

  final Episode episode;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const .all(24),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              _Cover(imageUrl: episode.cover, scheme: scheme, size: 24),
              8.gap,
              Expanded(
                child: Text(
                  (episode.channel?.title ?? '').toUpperCase(),
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: tt.labelSmall?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.85),
                    fontWeight: .w700,
                  ),
                ),
              ),
            ],
          ),
          4.gap,
          Expanded(
            child: Text(
              episode.title ?? '',
              maxLines: 2,
              overflow: .ellipsis,
              style: tt.headlineSmall?.copyWith(
                color: scheme.onPrimary,
                fontWeight: .w800,
              ),
            ),
          ),
          16.gap,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    WavyLinearProgressIndicator(
                      value: episode.progress.clamp(0.0, 1.0),
                      color: scheme.onPrimary,
                      trackColor: scheme.onPrimary.withValues(alpha: 0.25),
                      stopIndicatorColor: scheme.onPrimary,
                    ),
                    8.gap,
                    _TimeLeft(episode: episode, scheme: scheme),
                  ],
                ),
              ),
              16.gap,
              _PlayButton(episode: episode, scheme: scheme, size: 64),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniContent extends StatelessWidget {
  const _MiniContent({required this.episode, required this.scheme});

  final Episode episode;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const .fromLTRB(12, 8, 8, 8),
      child: Row(
        children: [
          _Cover(imageUrl: episode.cover, scheme: scheme, size: 40),
          12.gap,
          Expanded(
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .start,
              children: [
                Text(
                  episode.title ?? '',
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: tt.titleSmall?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: .w700,
                  ),
                ),
                _TimeLeft(episode: episode, scheme: scheme),
              ],
            ),
          ),
          8.gap,
          _PlayButton(episode: episode, scheme: scheme, size: 48),
        ],
      ),
    );
  }
}

class _TimeLeft extends StatelessWidget {
  const _TimeLeft({required this.episode, required this.scheme});

  final Episode episode;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;

    return Text(
      episode.played ? 'Played' : '${episode.remaining.remainingLabel} left',
      style: tt.labelMedium?.copyWith(
        color: scheme.onPrimary.withValues(alpha: 0.8),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.episode,
    required this.scheme,
    required this.size,
  });

  final Episode episode;
  final ColorScheme scheme;
  final double size;

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
              onTap: () {
                if (playing) {
                  HapticsHelper.light();
                  player.toggle();
                  return;
                }

                HapticsHelper.medium();
                current ? player.toggle() : player.play(episode);
              },
              child: SizedBox(
                width: size,
                height: size,
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
                        size: size / 2,
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
    required this.size,
  });

  final String imageUrl;
  final ColorScheme scheme;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: MaterialShapeBorder(shape: ShapeValues.coverFocused),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: SmoothImage(
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
        ),
      ),
    );
  }
}
