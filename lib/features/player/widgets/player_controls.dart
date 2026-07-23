import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.scheme,
    required this.playing,
    required this.fav,
    required this.onPlayPause,
    required this.onFav,
  });

  final ColorScheme scheme;
  final bool playing;
  final bool fav;
  final VoidCallback onPlayPause;
  final VoidCallback onFav;

  static const double _heroGap = 8;
  static const double _innerGap = 6;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = scheme;
    final Color tonal = cs.surfaceContainerHighest;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Play takes half the width, the 2x2 cluster the other half — so every
        // cell is a square that its button fills edge to edge.
        final double heroSide = (constraints.maxWidth - _heroGap) / 2;

        return SizedBox(
          height: heroSide,
          child: Row(
            children: [
              SizedBox(
                width: heroSide,
                height: heroSide,
                child: PlayButton(
                  playing: playing,
                  color: cs.onSurface,
                  foreground: cs.surface,
                  onTap: onPlayPause,
                ),
              ),
              _heroGap.gap,
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: SeekButton(
                              forward: false,
                              color: tonal,
                              iconColor: cs.onSurface,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: _innerGap),
                          Expanded(
                            child: SeekButton(
                              forward: true,
                              color: tonal,
                              iconColor: cs.onSurface,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: _innerGap,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: DownloadButton(
                              scheme: cs,
                            ),
                          ),
                          _innerGap.gap,
                          Expanded(
                            child: FavButton(
                              fav: fav,
                              scheme: cs,
                              onTap: onFav,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
