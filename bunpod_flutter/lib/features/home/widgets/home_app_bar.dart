import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_shapes/material_shapes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

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
                onTap: () {},
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
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MenuPage();
                  },
                ),
              );
            },
            customBorder: MaterialShapeBorder(
              shape: MaterialShapes.pill,
            ),
            child: ClipPath(
              clipper: ShapeBorderClipper(
                shape: MaterialShapeBorder(
                  shape: MaterialShapes.pill,
                ),
              ),
              child: const SizedBox(
                width: 32,
                height: 32,
                child: SmoothImage(
                  url: 'https://avatars.githubusercontent.com/u/59581562?v=4',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
