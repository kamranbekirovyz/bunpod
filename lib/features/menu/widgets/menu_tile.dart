import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';

/// A single row in a grouped settings list. Sized to the M3 list-item spec:
/// 56dp min height for one line, 72dp with a supporting line, 24dp leading
/// icon, 16dp horizontal padding. Corner radii are assigned by [MenuSection]
/// based on the tile's position within its group.
class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? background;
  final Color? foreground;
  final BorderRadius? borderRadius;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.background,
    this.foreground,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    final Color titleColor = foreground ?? cs.onSurface;
    final Color accessoryColor = foreground ?? cs.onSurfaceVariant;

    return Material(
      color: background ?? cs.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius:
            borderRadius ??
            BorderRadius.circular(
              MenuSection.innerRadius,
            ),
      ),
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: subtitle == null ? 56 : 72,
          ),
          child: Padding(
            padding: const .symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: accessoryColor,
                ),
                16.gap,
                Expanded(
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        title,
                        style: tt.bodyLarge?.copyWith(color: titleColor),
                      ),
                      if (subtitle != null) ...[
                        2.gap,
                        Text(
                          subtitle!,
                          style: tt.bodyMedium?.copyWith(
                            color: accessoryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  8.gap,
                  trailing!,
                ] else if (onTap != null) ...[
                  8.gap,
                  Icon(
                    Icons.chevron_right_rounded,
                    color: accessoryColor,
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
