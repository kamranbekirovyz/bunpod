import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_wavy_progress_indicator/material_wavy_progress_indicator.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({
    super.key,
    required this.episode,
    this.fromChannel = false,
  });

  final Episode episode;

  /// Whether the player was opened from this episode's channel page. When true,
  /// tapping the channel name pops back instead of pushing a duplicate page.
  final bool fromChannel;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool _fav = false;

  void _openChannel() {
    if (widget.fromChannel) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) {
          return ChannelPage(
            id: widget.episode.channelId,
            preview: ChannelPreview.fromChannel(widget.episode.channel),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Episode episode = widget.episode;
    final ColorScheme cs = episode.scheme(context);
    final TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        leading: const StyledBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.gap,
            GestureDetector(
              onTap: _openChannel,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (episode.channel?.title ?? '').toUpperCase(),
                    style: tt.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  4.gap,
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            12.gap,
            Padding(
              padding: const EdgeInsets.only(right: 56),
              child: Text(
                episode.title ?? '',
                style: tt.headlineLarge?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Spacer(),
            EpisodeProgressBuilder(
              episode: episode,
              builder: (context, episode) {
                return _Progress(episode: episode, scheme: cs);
              },
            ),
            24.gap,
            BlocBuilder<PlayerCubit, Playback>(
              bloc: locator<PlayerCubit>(),
              builder: (context, playback) {
                final PlayerCubit player = locator<PlayerCubit>();
                final bool current = playback.episode?.id == episode.id;

                return PlayerControls(
                  scheme: cs,
                  playing: current && playback.playing,
                  loading: current && playback.loading,
                  fav: _fav,
                  onPlayPause: () =>
                      current ? player.toggle() : player.play(episode),
                  onRewind: () => current ? player.rewind() : null,
                  onFastForward: () => current ? player.fastForward() : null,
                  onFav: () => setState(() => _fav = !_fav),
                );
              },
            ),
            const BottomPadding(),
          ],
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.episode, required this.scheme});

  final Episode episode;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final PlayerCubit player = locator<PlayerCubit>();
    final bool current = player.state.episode?.id == episode.id;
    final Duration loaded = current ? player.duration : Duration.zero;
    final Duration total = loaded > Duration.zero ? loaded : episode.total;
    final Duration position = episode.listened;
    final Duration remaining = total - position;
    final double progress = total.inMilliseconds == 0
        ? 0
        : position.inMilliseconds / total.inMilliseconds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          remaining > Duration.zero
              ? '-${remaining.remainingLabel}'
              : total.remainingLabel,
          textAlign: TextAlign.right,
          style: GoogleFonts.unbounded(
            color: scheme.onSurface,
            fontSize: 56,
            fontWeight: FontWeight.w700,
            letterSpacing: -2,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        8.gap,
        _ProgressBar(progress: progress, scheme: scheme),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.scheme});

  final double progress;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = scheme;
    return WavyLinearProgressIndicator(
      value: progress.clamp(0.0, 1.0),
      color: cs.primary,
      trackColor: cs.onSurface.withValues(alpha: 0.14),
      stopIndicatorColor: cs.primary,
    );
  }
}
