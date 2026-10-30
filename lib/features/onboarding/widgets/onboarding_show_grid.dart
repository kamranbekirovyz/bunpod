import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:expressive_shapes/expressive_shapes.dart';

class OnboardingShowGrid extends StatelessWidget {
  const OnboardingShowGrid({
    super.key,
    required this.shows,
    required this.followPicksCubit,
    required this.minPicks,
  });

  final List<ChannelPreview>? shows;
  final FollowPicksCubit followPicksCubit;
  final int minPicks;

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
        padding: const .symmetric(horizontal: 20),
        sliver: SliverGrid.builder(
          gridDelegate: _gridDelegate,
          itemCount: shows?.length ?? 12,
          itemBuilder: (BuildContext context, int index) {
            final ChannelPreview? podcast = shows?[index];

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
                  const ShimmerPlaceholder(
                    width: 72,
                    height: 12,
                  ),
                ],
              ),
              child: podcast == null
                  ? const SizedBox.shrink()
                  : StreamBuilder<Set<int>>(
                      stream: followPicksCubit.picked$,
                      initialData: followPicksCubit.picked,
                      builder: (context, snapshot) {
                        return OnboardingShowItem(
                          title: podcast.title ?? '',
                          author: podcast.author ?? '',
                          image: podcast.image ?? '',
                          selected: snapshot.requireData.contains(
                            podcast.appleId,
                          ),
                          onTap: () {
                            final int? appleId = podcast.appleId;
                            if (appleId == null) return;

                            followPicksCubit.toggle(appleId);

                            final bool unlocked =
                                followPicksCubit.picked.contains(appleId) &&
                                followPicksCubit.picked.length == minPicks;

                            unlocked
                                ? HapticsHelper.medium()
                                : HapticsHelper.selection();
                          },
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
