import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

class ExploreSearchField extends StatelessWidget {
  const ExploreSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final bool focused = focusNode.hasFocus;

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.standardSpatialFast(),
      value: focused ? 1.0 : 0.0,
      active: !reduceMotion,
      builder: (BuildContext context, double t, Widget? child) {
        final double tc = t.clamp(0.0, 1.0);

        return Material(
          color: Color.lerp(
            cs.surfaceContainerHigh,
            cs.surfaceContainerHighest,
            tc,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: .circular(28 - 10 * tc),
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        );
      },
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            16.gap,
            Icon(
              Icons.search_rounded,
              color: focused ? cs.primary : cs.onSurfaceVariant,
            ),
            12.gap,
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                style: tt.bodyLarge?.copyWith(color: cs.onSurface),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Shows, hosts, shelves…',
                  hintStyle: tt.bodyLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            if (controller.text.trim().isNotEmpty)
              IconButton(
                onPressed: onClear,
                tooltip: 'Clear search',
                icon: Icon(Icons.close_rounded, color: cs.onSurfaceVariant),
              )
            else
              8.gap,
          ],
        ),
      ),
    );
  }
}
