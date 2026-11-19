import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

class OpmlExportIdleView extends StatelessWidget {
  const OpmlExportIdleView({
    super.key,
    required this.channels,
    required this.busy,
    required this.onSave,
  });

  final List<Channel> channels;
  final bool busy;
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
          OpmlCoverStack(
            channels: channels.take(8).toList(),
          ),
          32.gap,
          OpmlImportHero(
            title: 'Your shows are yours',
            message:
                'They’ll fit right into any podcast app. No hard feelings.',
          ),
          64.gap,
          ExpressiveActionButton(
            label: 'Save OPML file',
            icon: Icons.download_rounded,
            busy: busy,
            onTap: onSave,
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
