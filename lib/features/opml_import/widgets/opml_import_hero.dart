import 'package:bunpod/bunpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class OpmlImportHero extends StatelessWidget {
  const OpmlImportHero({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          title,
          style: GoogleFonts.unbounded(
            textStyle: tt.headlineSmall,
            color: cs.onSurface,
            fontWeight: .w700,
          ),
        ),
        12.gap,
        Text(
          message,
          style: tt.bodyLarge?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
