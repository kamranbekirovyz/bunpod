import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<ThemeModeCubit>(ThemeModeCubit());
}
