import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

class OpmlImportFailedView extends StatelessWidget {
  const OpmlImportFailedView({
    super.key,
    required this.onPick,
  });

  final VoidCallback onPick;

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
                'Make sure it’s the file your old app gave you when you hit '
                '“Export”, and that you’re online. Trying again is totally '
                'fine.',
          ),
          64.gap,
          ExpressiveActionButton(
            label: 'Choose file',
            icon: Icons.upload_file_rounded,
            onTap: onPick,
            background: cs.primary,
            foreground: cs.onPrimary,
          ),
          const BottomPadding(),
        ],
      ),
    );
  }
}
