import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

/// Starts downloading Google Fonts that are only used on screens opened
/// later, so the text doesn't swap fonts the first time they appear.
Future<void> precacheFonts() {
  return GoogleFonts.pendingFonts([
    // Maker name in DeveloperSheet.
    GoogleFonts.googleSansCode(
      fontWeight: FontWeight.w700,
    ),
  ]);
}
