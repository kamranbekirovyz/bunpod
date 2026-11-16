import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

class OpmlImportIdleView extends StatelessWidget {
  const OpmlImportIdleView({
    super.key,
    required this.onPick,
  });

  final VoidCallback onPick;
  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const .symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: .end,
        crossAxisAlignment: .stretch,
        children: [
          OpmlImportHero(
            title: 'Move to BunPod',
            message:
                'Export your subscriptions from your old, less favorite '
                'podcast app, import the file here, and relax. We’ll '
                'take it from there.',
          ),
          32.gap,
          Material(
            color: cs.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: .circular(28),
            ),
            child: Padding(
              padding: const .all(20),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Wait, what file?',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: .w600,
                    ),
                  ),
                  8.gap,
                  Text(
                    'Poke around your old app’s settings for “Export”. '
                    'It gives you a small file (often ending in .opml) '
                    'with all your shows in it. That’s the one.',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          64.gap,
          ExpressiveActionButton(
            label: 'Choose OPML file',
            icon: Icons.upload_file_rounded,
            onTap: onPick,
            background: cs.primary,
            foreground: cs.onPrimary,
          ),
          8.gap,
          const BottomPadding(),
        ],
      ),
    );
  }
}
