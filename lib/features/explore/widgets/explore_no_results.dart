import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

class ExploreNoResults extends StatelessWidget {
  const ExploreNoResults({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const .fromLTRB(24, 64, 24, 0),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: cs.outline),
          12.gap,
          Text(
            'No shows match that.',
            style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
