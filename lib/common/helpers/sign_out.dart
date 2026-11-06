import 'package:bunpod/bunpod.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

Future<void> signOut() async {
  await locator<SecureStorageLocalData>().clearUser();
  await locator<PreferencesLocalData>().clearUser();
  await locator<FeedLocalData>().clear();
  await locator<SubscriptionsLocalData>().clear();
  await locator<PlayerHandler>().stop();
  await locator<SocialSignInService>().signOut();
  await UserOrient.logout();
  locator<UserCubit>().clear();
  locator<FeedCubit>().clear();
  locator<SubscriptionsCubit>().clear();
}
