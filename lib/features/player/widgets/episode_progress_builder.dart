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

        // While loading, the player reports position 0 before it seeks to
        // where the user left off, so keep showing the saved position.
        if (playback.episode?.id != episode.id || playback.loading) {
          return builder(context, saved);
        }

        return StreamBuilder<Duration>(
          stream: player.position,
          builder: (context, position) {
            return builder(
              context,
              saved.withPosition(position.data),
            );
          },
        );
      },
    );
  }
}
