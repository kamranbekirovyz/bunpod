import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const MaterialColor seedColor = MaterialColor(0xffF5A623, {});

abstract final class MaterialThemes {
  static ThemeData get light {
    return ThemeData(
      colorSchemeSeed: seedColor,
      brightness: .light,
      textTheme: GoogleFonts.googleSansTextTheme(),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      colorSchemeSeed: seedColor,
      brightness: .dark,
      textTheme: GoogleFonts.googleSansTextTheme(),
    );
  }
}
