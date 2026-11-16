import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:material_ui/material_ui.dart';

class OpmlImportBusyView extends StatelessWidget {
  const OpmlImportBusyView({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          SizedBox.square(
            dimension: 120,
            child: LoadingIndicator.contained(),
          ),
          24.gap,
          Text(
            'Bringing your shows over…',
            style: tt.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          120.gap,
        ],
      ),
    );
  }
}
