import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
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
            previous.positions[episode.id] != current.positions[episode.id];
      },
      builder: (context, playback) {
        final Episode saved = episode.withPosition(
          playback.positions[episode.id],
        );

        if (playback.episode?.id != episode.id) return builder(context, saved);

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
