import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

class OpmlExportFailedView extends StatelessWidget {
  const OpmlExportFailedView({
    super.key,
    required this.onSave,
  });

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const .symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: .end,
        crossAxisAlignment: .stretch,
        children: [
          const OpmlImportHero(
            title: 'That didn’t work',
            message:
                'The file couldn’t be saved. Trying again is totally fine.',
          ),
          64.gap,
          ExpressiveActionButton(
            label: 'Save OPML file',
            icon: Icons.download_rounded,
            onTap: onSave,
            background: cs.primary,
            foreground: cs.onPrimary,
          ),
          const BottomPadding(),
        ],
      ),
    );
  }
}
