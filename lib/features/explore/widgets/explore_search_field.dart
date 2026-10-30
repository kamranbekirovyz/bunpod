import 'dart:math' as math;

import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

class ExploreSearchField extends StatelessWidget {
  const ExploreSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.scrolled,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool scrolled;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    final Widget content = SizedBox(
      height: 56,
      child: Row(
        children: [
          16.gap,
          Icon(
            Icons.search_rounded,
            color: cs.onSurface,
          ),
          12.gap,
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              textInputAction: .search,
              autocorrect: false,
              enableSuggestions: false,
              cursorColor: cs.primary,
              style: tt.bodyLarge?.copyWith(
                color: cs.onSurface,
                height: 1,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: .none,
                hintText: 'Search shows and hosts',
                hintStyle: tt.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1,
                ),
              ),
            ),
          ),
          Padding(
            padding: const .only(right: 4),
            child: _ClearButton(
              visible: controller.text.isNotEmpty,
              onPressed: onClear,
            ),
          ),
        ],
      ),
    );

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.standardEffectsFast(),
      value: scrolled ? 1.0 : 0.0,
      active: !reduceMotion,
      builder: (context, t, content) {
        return Material(
          color: Color.lerp(
            cs.surfaceContainerHigh,
            cs.surfaceContainerHighest,
            t.clamp(0.0, 1.0),
          ),
          shape: const StadiumBorder(),
          clipBehavior: .antiAlias,
          child: content,
        );
      },
      child: content,
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({
    required this.visible,
    required this.onPressed,
  });

  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.expressiveSpatialFast(),
      value: visible ? 1.0 : 0.0,
      active: !MediaQuery.disableAnimationsOf(context),
      builder: (context, t, button) {
        return IgnorePointer(
          ignoring: !visible,
          child: Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.rotate(
              angle: (1 - t) * -math.pi / 2,
              child: Transform.scale(
                scale: math.max(t, 0),
                child: button,
              ),
            ),
          ),
        );
      },
      child: IconButton(
        onPressed: onPressed,
        tooltip: 'Clear',
        icon: Icon(
          Icons.close_rounded,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
