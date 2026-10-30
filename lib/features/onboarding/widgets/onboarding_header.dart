import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key, required this.minPicks});

  final int minPicks;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: cs.secondaryContainer,
              shape: const StadiumBorder(),
            ),
            child: Padding(
              padding: const .symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: .min,
                children: [
                  Icon(
                    Icons.near_me_rounded,
                    size: 16,
                    color: cs.onSecondaryContainer,
                  ),
                  6.gap,
                  Text(
                    'Popular near you',
                    style: tt.labelLarge?.copyWith(
                      color: cs.onSecondaryContainer,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        16.gap,
        Text(
          'Pick your shows.',
          style: tt.headlineLarge?.copyWith(
            color: cs.onSurface,
            fontWeight: .w800,
            letterSpacing: -0.5,
          ),
        ),
        12.gap,
        Text(
          'These are trending with listeners around you. Choose '
          '$minPicks or more and we’ll shape your feed around them.',
          style: tt.bodyLarge?.copyWith(
            color: cs.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
