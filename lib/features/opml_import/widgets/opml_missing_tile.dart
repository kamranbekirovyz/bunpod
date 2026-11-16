import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:motor/motor.dart';

class OpmlMissingTile extends StatefulWidget {
  const OpmlMissingTile({
    super.key,
    required this.feeds,
  });

  final List<OpmlFeed> feeds;

  @override
  State<OpmlMissingTile> createState() => _OpmlMissingTileState();
}

class _OpmlMissingTileState extends State<OpmlMissingTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final int count = widget.feeds.length;

    return Material(
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: .circular(28)),
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: () {
          HapticsHelper.selection();
          setState(() => _open = !_open);
        },
        child: Padding(
          padding: const .all(16),
          child: AnimatedSize(
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            alignment: .topCenter,
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: cs.surfaceContainerHighest,
                        shape: MaterialShapeBorder(
                          shape: MaterialShapes.cookie4Sided,
                        ),
                      ),
                      child: Icon(
                        Icons.search_off_rounded,
                        size: 20,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    14.gap,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            count == 1
                                ? '1 show couldn’t come along'
                                : '$count shows couldn’t come along',
                            style: tt.bodyLarge,
                          ),
                          Text(
                            'Usually private, paid, or ended',
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleMotionBuilder(
                      motion:
                          const MaterialSpringMotion.expressiveSpatialFast(),
                      value: _open ? 0.5 : 0,
                      active: !reduceMotion,
                      builder: (context, turns, child) {
                        return Transform.rotate(
                          angle: turns * 2 * 3.141592653589793,
                          child: child,
                        );
                      },
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (_open) ...[
                  12.gap,
                  for (final OpmlFeed feed in widget.feeds)
                    Padding(
                      padding: const .fromLTRB(54, 6, 8, 6),
                      child: Text(
                        feed.title ?? 'Untitled show',
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
