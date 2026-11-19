import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

class OpmlExportReadyView extends StatelessWidget {
  const OpmlExportReadyView({
    super.key,
    required this.channels,
  });

  final List<Channel> channels;

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
            title: 'Packed and ready',
            message:
                'Your ${channels.length} shows are saved. The door’s always open.',
          ),
          64.gap,
          ExpressiveActionButton(
            label: 'Done',
            onTap: Navigator.of(context).pop,
            background: cs.tertiary,
            foreground: cs.onTertiary,
          ),
          8.gap,
          const BottomPadding(),
        ],
      ),
    );
  }
}
