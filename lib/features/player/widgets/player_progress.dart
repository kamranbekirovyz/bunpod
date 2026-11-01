import 'package:bunpod/bunpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:material_wavy_progress_indicator/material_wavy_progress_indicator.dart';
import 'package:motor/motor.dart';

/// Time left above a wavy bar you can drag or tap to seek. The wave flattens
/// and thickens under the finger, and the time follows the drag.
class PlayerProgress extends StatefulWidget {
  const PlayerProgress({
    super.key,
    required this.episode,
    required this.scheme,
  });

  final Episode episode;
  final ColorScheme scheme;

  @override
  State<PlayerProgress> createState() => _PlayerProgressState();
}

class _PlayerProgressState extends State<PlayerProgress> {
  static const int _ticks = 20;

  double? _scrub;
  bool _dragging = false;

  int _step(double value) => (value * _ticks).round();

  double _fraction(Offset position, double width) {
    return (position.dx / width).clamp(0.0, 1.0);
  }

  void _start(double value) {
    setState(() {
      _dragging = true;
      _scrub = value;
    });

    HapticsHelper.light();
  }

  void _update(double value) {
    final double? previous = _scrub;
    if (previous == null) return;

    if ((value == 0 || value == 1) && value != previous) {
      HapticsHelper.rigid();
    } else if (_step(value) != _step(previous)) {
      HapticsHelper.selection();
    }

    setState(() => _scrub = value);
  }

  Future<void> _seek(double value) async {
    setState(() {
      _dragging = false;
      _scrub = value;
    });

    await locator<PlayerCubit>().seekEpisode(
      widget.episode,
      widget.episode.total * value,
    );

    if (!mounted || _dragging) return;

    setState(() {
      _scrub = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = widget.scheme;
    final Episode episode = widget.episode;
    final double? scrub = _scrub;
    final Episode shown = scrub == null
        ? episode
        : episode.withPosition(episode.total * scrub);

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(
          switch (shown) {
            Episode(played: true) when scrub == null => 'Played',
            Episode(listened: > Duration.zero) =>
              '-${shown.remaining.remainingLabel}',
            _ => shown.total.remainingLabel,
          },
          textAlign: .right,
          style: GoogleFonts.unbounded(
            color: cs.onSurface,
            fontSize: 56,
            fontWeight: .w700,
            letterSpacing: -2,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            return GestureDetector(
              behavior: .opaque,
              onHorizontalDragStart: (details) {
                _start(_fraction(details.localPosition, width));
              },
              onHorizontalDragUpdate: (details) {
                _update(_fraction(details.localPosition, width));
              },
              onHorizontalDragEnd: (_) {
                _seek(_scrub ?? episode.progress);
              },
              onHorizontalDragCancel: () {
                setState(() {
                  _dragging = false;
                  _scrub = null;
                });
              },
              onLongPressStart: (details) {
                _start(_fraction(details.localPosition, width));
              },
              onLongPressMoveUpdate: (details) {
                _update(_fraction(details.localPosition, width));
              },
              onLongPressEnd: (_) {
                _seek(_scrub ?? episode.progress);
              },
              onLongPressCancel: () {
                setState(() {
                  _dragging = false;
                  _scrub = null;
                });
              },
              onTapUp: (details) {
                _seek(_fraction(details.localPosition, width));

                HapticsHelper.light();
              },
              child: SizedBox(
                height: 48,
                child: Center(
                  child: _SeekBar(
                    value: shown.progress,
                    dragging: _dragging,
                    scheme: cs,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SeekBar extends StatelessWidget {
  const _SeekBar({
    required this.value,
    required this.dragging,
    required this.scheme,
  });

  final double value;
  final bool dragging;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.expressiveSpatialFast(),
      value: dragging ? 1 : 0,
      active: !MediaQuery.disableAnimationsOf(context),
      builder: (context, t, _) {
        final double grab = t.clamp(0.0, 1.0);

        return WavyLinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          color: scheme.primary,
          trackColor: scheme.onSurface.withValues(alpha: 0.14),
          stopIndicatorColor: scheme.primary,
          strokeWidth: 4 + 2 * grab,
          stopIndicatorWidth: 4 + 2 * grab,
          amplitude: 3 * (1 - grab),
        );
      },
    );
  }
}
