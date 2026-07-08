import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const MaterialColor seedColor = MaterialColor(0xffF5A623, {});

const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
  builders: {
    .android: FadeForwardsPageTransitionsBuilder(),
    .iOS: FadeForwardsPageTransitionsBuilder(),
  },
);

abstract final class MaterialThemes {
  static ThemeData get light => _theme(.light);

  static ThemeData get dark => _theme(.dark);

  // GoogleFonts.googleSansTextTheme() without a base bakes in light-theme
  // text colors, breaking dark mode; derive it from the brightness-correct
  // base theme instead.
  static ThemeData _theme(Brightness brightness) {
    final ThemeData base = ThemeData(
      colorSchemeSeed: Colors.primaries.elementAt(12),
      brightness: brightness,
    );

    return base.copyWith(
      textTheme: GoogleFonts.googleSansTextTheme(base.textTheme),
      pageTransitionsTheme: _pageTransitionsTheme,
    );
  }
}
