import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versionarte/versionarte.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final bool useMocks = AppConfig.useMocks;

  locator.registerSingleton<SecureStorageLocalData>(
    const SecureStorageLocalData(),
  );
  locator.registerSingleton<PreferencesLocalData>(
    PreferencesLocalData(
      sharedPreferences: await SharedPreferences.getInstance(),
    ),
  );
  locator.registerSingleton<ThemeModeCubit>(ThemeModeCubit());
  locator.registerSingleton<SocialSignInService>(
    useMocks ? const MockSocialSignInService() : const SocialSignInService(),
  );
  locator.registerSingleton<AuthRemoteData>(
    useMocks ? const MockAuthRemoteData() : const AuthRemoteData(),
  );
  locator.registerSingleton<FeedRemoteData>(
    useMocks ? const MockFeedRemoteData() : const FeedRemoteData(),
  );
  locator.registerSingleton<SubscriptionsRemoteData>(
    useMocks
        ? const MockSubscriptionsRemoteData()
        : const SubscriptionsRemoteData(),
  );
  locator.registerSingleton<OnboardingRemoteData>(
    useMocks ? const MockOnboardingRemoteData() : const OnboardingRemoteData(),
  );
  locator.registerSingleton<ExploreRemoteData>(
    useMocks ? const MockExploreRemoteData() : const ExploreRemoteData(),
  );
  locator.registerSingleton<ChannelRemoteData>(
    useMocks ? const MockChannelRemoteData() : const ChannelRemoteData(),
  );
  locator.registerSingleton<PlaybackRemoteData>(
    useMocks ? const MockPlaybackRemoteData() : const PlaybackRemoteData(),
  );
  locator.registerSingleton<ProfileRemoteData>(
    useMocks ? const MockProfileRemoteData() : const ProfileRemoteData(),
  );
  locator.registerSingleton<PlayerHandler>(await PlayerHandler.init());
  locator.registerSingleton<VersionarteProvider>(
    useMocks
        ? const MockVersionarteProvider()
        : const RemoteConfigVersionarteProvider(),
  );
  locator.registerSingleton<VersionarteCubit>(VersionarteCubit());
  locator.registerSingleton<FeedCubit>(FeedCubit());
  locator.registerSingleton<SubscriptionsCubit>(SubscriptionsCubit());
  locator.registerSingleton<ExploreCategoriesCubit>(ExploreCategoriesCubit());
  locator.registerSingleton<PlayerCubit>(PlayerCubit());
  locator.registerSingleton<UserCubit>(UserCubit());
  // Last, since the interceptor reads tokens from the locator.
  locator.registerSingleton<Dio>(buildDio());
}
