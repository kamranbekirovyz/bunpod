import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
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

  static Route<void> route(Episode episode, {bool fromChannel = false}) {
    return MaterialPageRoute<void>(
      builder: (context) =>
          PlayerPage(episode: episode, fromChannel: fromChannel),
    );
  }

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late bool _playing = widget.episode.playing;
  bool _fav = false;

  void _openChannel() {
    if (widget.fromChannel) {
      Navigator.of(context).pop();
      return;
    }
    final Channel? channel = channelByName(widget.episode.channel);
    if (channel != null) {
      Navigator.of(context).push(ChannelPage.route(channel));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Episode episode = widget.episode;
    final ColorScheme cs = episode.scheme(context);
    final TextTheme tt = Theme.of(context).textTheme;

    final Duration remaining = episode.total - episode.listened;
    // Finished episodes have nothing left to count down — show the full
    // duration again, without the leading minus.
    final bool ended = remaining <= Duration.zero;
    final String timeLabel = ended
        ? episode.total.remainingLabel
        : '-${remaining.remainingLabel}';

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
                    episode.channel.toUpperCase(),
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
                episode.title,
                style: tt.displaySmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeLabel,
                style: GoogleFonts.unbounded(
                  color: cs.onSurface,
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -2,
                  fontFeatures: const [
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
            8.gap,
            _ProgressBar(
              progress: episode.progress,
              scheme: cs,
            ),
            24.gap,
            PlayerControls(
              scheme: cs,
              playing: _playing,
              fav: _fav,
              onPlayPause: () => setState(() => _playing = !_playing),
              onFav: () => setState(() => _fav = !_fav),
            ),
          ],
        ),
      ),
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
