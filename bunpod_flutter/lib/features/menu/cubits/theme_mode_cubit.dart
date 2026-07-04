import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit() : super(.system);

  Future<void> toggle() async {
    final ThemeMode newMode = state == .light ? .dark : .light;

    emit(newMode);
  }
}
