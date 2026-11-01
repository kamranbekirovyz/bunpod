import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

/// The pill once it has left the top, springing in from the bottom edge.
class FeedDockedPlayer extends StatelessWidget {
  const FeedDockedPlayer({
    super.key,
    required this.header,
    required this.suggested,
  });

  final FeedHeaderController header;
  final Episode? suggested;

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return ValueListenableBuilder<double>(
      valueListenable: header.shrink,
      builder: (context, _, child) {
        final bool docked = header.docked;

        return SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialDefault(),
          value: docked ? 1 : 0,
          active: !reduceMotion,
          builder: (context, t, child) {
            final double shown = t.clamp(0.0, 1.0);

            return IgnorePointer(
              ignoring: !docked,
              child: Opacity(
                opacity: shown,
                child: Transform.translate(
                  offset: Offset(0, (1 - t) * 96),
                  child: Transform.scale(
                    scale: 0.9 + 0.1 * shown,
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: child,
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: .circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FeedNowPlaying(suggested: suggested, collapse: 1),
      ),
    );
  }
}
