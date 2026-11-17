import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Follow = ({bool subscribed, bool busy});

class ChannelFollowCubit extends Cubit<Follow?> {
  ChannelFollowCubit([bool? subscribed]) : super(_idle(subscribed));

  static Follow? _idle(bool? subscribed) {
    return subscribed == null ? null : (subscribed: subscribed, busy: false);
  }

  static bool succeeded(Follow? previous, Follow? current) {
    return previous?.busy == true &&
        current?.busy == false &&
        previous?.subscribed == current?.subscribed;
  }

  SubscriptionsLocalData get _local => locator<SubscriptionsLocalData>();

  Future<void> load({required int id}) async {
    emit(_idle(await _local.isSubscribed(id)));
  }

  Future<void> toggle(Channel channel) async {
    final Follow? follow = state;
    final int? id = channel.id;
    if (follow == null || follow.busy || id == null) return;

    final bool next = !follow.subscribed;

    emit((subscribed: next, busy: true));

    try {
      next ? await _local.subscribe([channel]) : await _local.unsubscribe(id);
      emit((subscribed: next, busy: false));
    } catch (_) {
      emit((subscribed: !next, busy: false));
    }
  }
}
