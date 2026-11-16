import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expressive_shapes/expressive_shapes.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Center(
      widthFactor: 1,
      child: ConstrainedBox(
        // room for the back button, the rest is the chip's
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width - 96,
        ),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: cs.surfaceContainer,
            shape: const StadiumBorder(),
          ),
          child: Padding(
            padding: const .fromLTRB(3, 3, 10, 3),
            child: Row(
              mainAxisSize: .min,
              children: [
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: MaterialShapeBorder(
                      shape: MaterialShapes.cookie7Sided,
                    ),
                  ),
                  child: const SizedBox.square(
                    dimension: 22,
                    child: UserAvatar(),
                  ),
                ),
                6.gap,
                Flexible(
                  child: BlocBuilder<UserCubit, User?>(
                    bloc: locator<UserCubit>(),
                    builder: (context, user) {
                      final bool loading = user == null;
                      final String? name = user?.name?.trim();

                      // no name, e.g. apple sign in
                      final String label = name != null && name.isNotEmpty
                          ? name
                          : user?.email ?? '';

                      return ShimmerScope(
                        active: loading,
                        child: ShimmerReveal(
                          loading: loading,
                          placeholder: const ShimmerPlaceholder(
                            width: 72,
                            height: 10,
                          ),
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: tt.labelMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
