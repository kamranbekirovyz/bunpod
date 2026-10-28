import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';

class ExploreShowGrid extends StatelessWidget {
  const ExploreShowGrid({
    super.key,
    required this.shows,
  });

  final List<ChannelPreview>? shows;

  static const SliverGridDelegate _gridDelegate =
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      );

  @override
  Widget build(BuildContext context) {
    final List<ChannelPreview>? shows = this.shows;
    final bool loading = shows == null;

    return ShimmerScope(
      active: loading,
      child: SliverPadding(
        padding: const .fromLTRB(20, 16, 20, 0),
        sliver: SliverGrid.builder(
          gridDelegate: _gridDelegate,
          itemCount: shows?.length ?? 12,
          itemBuilder: (BuildContext context, int index) {
            final ChannelPreview? show = shows?[index];

            return ShimmerReveal(
              loading: loading,
              delay: Duration(milliseconds: 40 * (index ~/ 3 + index % 3)),
              placeholder: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ShimmerPlaceholder(
                      shape: MaterialShapeBorder(
                        shape: MaterialShapes.square,
                      ),
                    ),
                  ),
                  12.gap,
                  const ShimmerPlaceholder(width: 72, height: 12),
                ],
              ),
              child: show == null
                  ? const SizedBox.shrink()
                  : ExploreChannelItem(channel: show),
            );
          },
        ),
      ),
    );
  }
}
