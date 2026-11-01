import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// The playing episode, or [suggested] when nothing has played yet.
class FeedNowPlaying extends StatelessWidget {
  const FeedNowPlaying({
    super.key,
    required this.suggested,
    required this.collapse,
    this.onCardHeight,
  });

  final Episode? suggested;
  final double collapse;
  final ValueChanged<double>? onCardHeight;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlayerCubit, Playback, Episode?>(
      bloc: locator<PlayerCubit>(),
      selector: (playback) => playback.episode,
      builder: (context, playing) {
        final Episode? shown = playing ?? suggested;

        if (shown == null) return const SizedBox.shrink();

        return EpisodeProgressBuilder(
          episode: shown,
          builder: (context, episode) {
            return FeedNowPlayingCard(
              episode: episode,
              collapse: collapse,
              onExpandedHeight: onCardHeight,
            );
          },
        );
      },
    );
  }
}
