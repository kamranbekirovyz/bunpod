import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionsCubit extends Cubit<List<Channel>?> {
  SubscriptionsCubit() : super(null);

  SubscriptionsLocalData get _local => locator<SubscriptionsLocalData>();

  /// Shows the last synced subscriptions, if any, without a request.
  Future<void> restore() async {
    final List<Channel> cached = await _local.subscriptions();

    if (state == null && cached.isNotEmpty) emit(cached);
  }

  /// Fetches the subscriptions and caches them. Runs after every follow and
  /// unfollow, so the cache always matches the server.
  Future<void> load() async {
    final List<Channel> channels = await locator<SubscriptionsRemoteData>()
        .subscriptions();

    await _local.cacheSubscriptions(channels);

    emit(channels);
  }

  void clear() {
    emit(null);
  }
}
