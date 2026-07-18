import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.first,
    required this.last,
    required this.onTap,
  });

  final ExploreCategory category;
  final bool first;
  final bool last;
  final VoidCallback onTap;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = widget.category.scheme(context);
    final TextTheme tt = Theme.of(context).textTheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final List<Channel> channels = widget.category.channels;

    final BorderRadius radius = BorderRadius.vertical(
      top: Radius.circular(widget.first ? 28 : 10),
      bottom: Radius.circular(widget.last ? 28 : 10),
    );

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.standardSpatialFast(),
      value: _pressed ? 1.0 : 0.0,
      active: !reduceMotion,
      builder: (BuildContext context, double t, Widget? child) {
        return Transform.scale(
          scale: 1 - 0.02 * t.clamp(0.0, 1.0),
          child: child,
        );
      },
      child: Material(
        color: scheme.primaryContainer,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: _setPressed,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        widget.category.name,
                        style: tt.titleLarge?.copyWith(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.gap,
                      Text(
                        '${channels.length} shows',
                        style: tt.labelLarge?.copyWith(
                          color: scheme.onPrimaryContainer.withValues(
                            alpha: 0.72,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                12.gap,
                _CoverFan(
                  channels: channels,
                  border: scheme.primaryContainer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Up to three covers leaning at alternating angles, overlapped like spines
/// on a shelf.
class _CoverFan extends StatelessWidget {
  const _CoverFan({required this.channels, required this.border});

  final List<Channel> channels;
  final Color border;

  static const double _size = 48;
  static const double _step = 26;
  static const List<double> _angles = <double>[-0.09, 0.07, -0.04];

  @override
  Widget build(BuildContext context) {
    final int count = channels.length.clamp(0, 3);
    if (count == 0) return const SizedBox.shrink();

    return SizedBox(
      width: _size + _step * (count - 1),
      height: _size + 8,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          for (int i = 0; i < count; i++)
            Positioned(
              left: i * _step,
              child: Transform.rotate(
                angle: _angles[i],
                child: Container(
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border, width: 2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SmoothImage(
                    url: channels[i].image,
                    placeholderColor: channels[i].seed,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
