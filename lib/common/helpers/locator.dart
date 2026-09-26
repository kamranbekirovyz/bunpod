import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:versionarte/versionarte.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<ThemeModeCubit>(ThemeModeCubit());

  final bool useMocks = AppConfig.useMocks;

  locator.registerSingleton<SecureStorageLocalData>(
    const SecureStorageLocalData(),
  );
  locator.registerSingleton<SocialSignInService>(
    useMocks ? const MockSocialSignInService() : const SocialSignInService(),
  );
  locator.registerSingleton<AuthRemoteData>(
    useMocks ? const MockAuthRemoteData() : const AuthRemoteData(),
  );
  locator.registerSingleton<VersionarteProvider>(
    useMocks
        ? const MockVersionarteProvider()
        : const RemoteConfigVersionarteProvider(),
  );
  locator.registerSingleton<VersionarteCubit>(VersionarteCubit());
  // Last, since the interceptor reads tokens from the locator.
  locator.registerSingleton<Dio>(buildDio());
}
