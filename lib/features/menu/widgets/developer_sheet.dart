import 'package:bunpod/bunpod.dart';
import 'package:expressive_sheet/expressive_sheet.dart';
import 'package:expressive_snack/expressive_snack.dart';
import 'package:material_ui/material_ui.dart'
    hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperSheet extends StatelessWidget {
  const DeveloperSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showExpressiveSheet<void>(
      context: context,
      builder: (context) {
        return const DeveloperSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: .all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
        ),
        child: Material(
          color: cs.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            // Concentric with the 28-radius buttons behind 24 padding.
            borderRadius: .circular(52),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const .all(24),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                Center(
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: MaterialShapeBorder(
                        shape: MaterialShapes.bun,
                      ),
                    ),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: SmoothImage(
                        url: AppValues.makerImageUrl,
                      ),
                    ),
                  ),
                ),
                16.gap,
                Text(
                  AppValues.makerName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.googleSansCode(
                    textStyle: tt.titleLarge,
                    fontWeight: .w700,
                  ),
                ),
                16.gap,
                Padding(
                  padding: const .symmetric(horizontal: 8),
                  child: Text(
                    'Want your app built with this much care? '
                    "Let's work together.",
                    textAlign: .center,
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
                24.gap,
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(textStyle: tt.titleMedium),
                    onPressed: () {
                      launchUrl(
                        Uri.parse(AppValues.makerXUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    icon: const Icon(Icons.alternate_email_rounded),
                    label: const Text('Follow on X'),
                  ),
                ),
                8.gap,
                SizedBox(
                  height: 56,
                  child: FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(textStyle: tt.titleMedium),
                    onPressed: () {
                      launchUrl(
                        Uri.parse(AppValues.makerPortfolioUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    icon: const Icon(Icons.language_rounded),
                    label: const Text('Check my works'),
                  ),
                ),
                8.gap,
                SizedBox(
                  height: 56,
                  child: FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(textStyle: tt.titleMedium),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: AppValues.makerEmail),
                      );
                      Navigator.of(context).pop();
                      showExpressiveSnack(
                        context: context,
                        message: '${AppValues.makerEmail} copied',
                        icon: Icons.copy_rounded,
                      );
                    },
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('Copy my email'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
