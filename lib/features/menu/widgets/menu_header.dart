import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart' hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expressive_shapes/expressive_shapes.dart';

/// Menu page header: the user's avatar in a pill shape, with their name and
/// email beside it.
class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const .symmetric(horizontal: 8),
      child: Row(
        children: [
          ClipPath(
            clipper: ShapeBorderClipper(
              shape: MaterialShapeBorder(
                shape: MaterialShapes.pill,
              ),
            ),
            child: const SizedBox.square(
              dimension: 64,
              child: UserAvatar(),
            ),
          ),
          16.gap,
          Expanded(
            child: BlocBuilder<UserCubit, User?>(
              bloc: locator<UserCubit>(),
              builder: (context, user) {
                final bool loading = user == null;

                return ShimmerScope(
                  active: loading,
                  child: ShimmerReveal(
                    loading: loading,
                    placeholder: Column(
                      crossAxisAlignment: .start,
                      children: [
                        const ShimmerPlaceholder(width: 140, height: 18),
                        8.gap,
                        const ShimmerPlaceholder(width: 180, height: 12),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          user?.name ?? '',
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: GoogleFonts.unbounded(
                            textStyle: tt.titleMedium,
                            fontWeight: .w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (user?.email case final String email)
                          Text(
                            email,
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: tt.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
