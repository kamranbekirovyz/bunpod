import 'package:bunpod/bunpod.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<ThemeModeCubit>(ThemeModeCubit());
}
