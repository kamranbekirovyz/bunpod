import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:expressive_shapes/expressive_shapes.dart';

class FeedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FeedAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Row(
        children: [
          SvgPicture.asset(
            isDark
                ? AssetValues.logoHorizontalDark
                : AssetValues.logoHorizontalLight,
            height: 36,
          ),
          const Spacer(),
          Tooltip(
            message: 'Explore',
            child: Material(
              color: cs.secondaryContainer,
              shape: MaterialShapeBorder(
                shape: MaterialShapes.cookie7Sided,
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  ExplorePage.show(context);
                },
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.add_rounded,
                    color: cs.onSecondaryContainer,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: 'Menu',
            child: Material(
              color: cs.surfaceContainerHigh,
              shape: MaterialShapeBorder(
                shape: MaterialShapes.pill,
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const MenuPage();
                      },
                    ),
                  );
                },
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.menu_rounded,
                    color: cs.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
