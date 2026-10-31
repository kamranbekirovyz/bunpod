import 'package:google_fonts/google_fonts.dart';

Future<void> precacheFonts() async {
  await GoogleFonts.pendingFonts([
    GoogleFonts.googleSans(fontWeight: .w400),
    GoogleFonts.googleSans(fontWeight: .w500),
    GoogleFonts.googleSans(fontWeight: .w700),
  ]);

  _precacheOtherFonts();
}

Future<void> _precacheOtherFonts() async {
  await GoogleFonts.pendingFonts([
    GoogleFonts.unbounded(fontWeight: .w600),
    GoogleFonts.unbounded(fontWeight: .w700),
    GoogleFonts.googleSansCode(fontWeight: .w500),
    GoogleFonts.googleSansCode(fontWeight: .w700),
    GoogleFonts.nanumPenScript(fontWeight: .w500),
  ]);
}
