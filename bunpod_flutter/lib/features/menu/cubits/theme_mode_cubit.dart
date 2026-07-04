import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit() : super(.system);

  // TOOD: persist to shared preferences
  Future<void> toggle() async {
    final ThemeMode newMode = state == .light ? .dark : .light;

    emit(newMode);
  }
}
