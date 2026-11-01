import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EpisodeProgressBuilder extends StatelessWidget {
  const EpisodeProgressBuilder({
    super.key,
    required this.episode,
    required this.builder,
  });

  final Episode episode;
  final Widget Function(BuildContext context, Episode episode) builder;

  @override
  Widget build(BuildContext context) {
    final PlayerCubit player = locator<PlayerCubit>();

    return BlocBuilder<PlayerCubit, Playback>(
      bloc: player,
      buildWhen: (previous, current) {
        return previous.episode?.id != current.episode?.id ||
            previous.loading != current.loading ||
            previous.positions[episode.id] != current.positions[episode.id];
      },
      builder: (context, playback) {
        final Episode saved = episode.withPosition(
          playback.positions[episode.id],
        );

        if (playback.episode?.id != episode.id) {
          return builder(context, saved);
        }

        return StreamBuilder<Duration>(
          stream: player.position,
          initialData: player.currentPosition,
          builder: (context, snapshot) {
            final Duration position = snapshot.data ?? Duration.zero;

            // Opening an episode, the player reports 0 before it seeks to
            // where the user left off. Seeking only buffers, so the live
            // position stays.
            if (playback.loading && position == Duration.zero) {
              return builder(context, saved);
            }

            return builder(context, saved.withPosition(position));
          },
        );
      },
    );
  }
}
