import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

class OpmlImportSummary extends StatelessWidget {
  const OpmlImportSummary({
    super.key,
    required this.result,
  });

  final OpmlImport result;

  @override
  Widget build(BuildContext context) {
    final int added = result.subscribed.length;
    final int open = result.suggestions.length;
    final String unsure = open == 1
        ? 'Not sure about 1 show, help us out below.'
        : 'Not sure about $open shows, help us out below.';

    final String title;
    final String message;
    if (added > 0) {
      title = added == 1 ? '1 show moved in' : '$added shows moved in';
      message = open > 0 ? unsure : 'They’re in your feed now.';
    } else if (open > 0) {
      title = 'Almost there';
      message = unsure;
    } else {
      title = 'Hmm, nothing came along';
      message =
          'We couldn’t find any of these shows. They might be private, '
          'paid, or gone for good.';
    }

    return Column(
      crossAxisAlignment: .start,
      children: [
        if (added > 0) ...[
          OpmlCoverStack(
            channels: result.subscribed,
          ),
          24.gap,
        ],
        OpmlImportHero(
          title: title,
          message: message,
        ),
      ],
    );
  }
}
