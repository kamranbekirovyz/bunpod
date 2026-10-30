import 'dart:ui';

import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit() : super(locator<PreferencesLocalData>().themeMode);

  void set(ThemeMode mode) {
    if (mode == state) return;

    emit(mode);
    locator<PreferencesLocalData>().cacheThemeMode(mode);
  }

  void toggle() {
    final Brightness system = PlatformDispatcher.instance.platformBrightness;

    final bool isDark = switch (state) {
      .dark => true,
      .light => false,
      .system => system == .dark,
    };

    set(isDark ? .light : .dark);
  }
}
