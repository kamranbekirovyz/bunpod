import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versionarte/versionarte.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<Dio>(buildDio());
  locator.registerSingleton<PodcastIndexRemoteData>(
    const PodcastIndexRemoteData(),
  );
  locator.registerSingleton<ApplePodcastsRemoteData>(
    const ApplePodcastsRemoteData(),
  );
  locator.registerSingleton<RssRemoteData>(const RssRemoteData());

  locator.registerSingleton<PreferencesLocalData>(
    PreferencesLocalData(
      sharedPreferences: await SharedPreferences.getInstance(),
    ),
  );
  locator.registerSingleton<AppDatabase>(AppDatabase());
  locator.registerSingleton<SubscriptionsLocalData>(
    const SubscriptionsLocalData(),
  );
  locator.registerSingleton<EpisodesLocalData>(const EpisodesLocalData());
  locator.registerSingleton<PlaybackLocalData>(const PlaybackLocalData());

  locator.registerSingleton<FeedSync>(FeedSync());
  locator.registerSingleton<OpmlImporter>(const OpmlImporter());
  locator.registerSingleton<LegacySubscriptionsMigration>(
    const LegacySubscriptionsMigration(),
  );
  locator.registerSingleton<PlayerHandler>(await PlayerHandler.init());
  locator.registerSingleton<VersionarteProvider>(
    const RemoteConfigVersionarteProvider(),
  );

  locator.registerSingleton<ThemeModeCubit>(ThemeModeCubit());
  locator.registerSingleton<ChannelColorsCubit>(ChannelColorsCubit());
  locator.registerSingleton<VersionarteCubit>(VersionarteCubit());
  locator.registerSingleton<ChangelogCubit>(ChangelogCubit());
  locator.registerSingleton<SubscriptionsCubit>(SubscriptionsCubit());
  locator.registerSingleton<FeedCubit>(FeedCubit());
  locator.registerSingleton<PlayerCubit>(PlayerCubit());
}
