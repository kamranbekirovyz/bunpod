import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

class OpmlImportReadyView extends StatelessWidget {
  const OpmlImportReadyView({
    super.key,
    required this.result,
    required this.onPick,
  });

  final OpmlImport result;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool nothing =
        result.subscribed.isEmpty && result.suggestions.isEmpty;

    return Stack(
      children: [
        ProgressiveFade(
          edge: .bottomCenter,
          inset: 0 + BottomPadding.of(context),
          height: 96,
          child: ListView(
            padding: .fromLTRB(
              16,
              8,
              16,
              120 + BottomPadding.of(context),
            ),
            children: [
              Padding(
                padding: const .symmetric(horizontal: 8),
                child: OpmlImportSummary(
                  result: result,
                ),
              ),
              if (result.suggestions.isNotEmpty) ...[
                40.gap,
                OpmlSuggestionDeck(
                  suggestions: result.suggestions,
                ),
              ],
              if (result.unavailable.isNotEmpty) ...[
                32.gap,
                OpmlMissingTile(
                  feeds: result.unavailable,
                ),
              ],
            ],
          ),
        ),
        Align(
          alignment: .bottomCenter,
          child: Padding(
            padding: .fromLTRB(
              24,
              40,
              24,
              BottomPadding.of(context),
            ),
            child: ExpressiveActionButton(
              label: nothing ? 'Try another file' : 'Done',
              icon: nothing ? Icons.upload_file_rounded : null,
              onTap: nothing ? onPick : Navigator.of(context).pop,
              background: cs.tertiary,
              foreground: cs.onTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
