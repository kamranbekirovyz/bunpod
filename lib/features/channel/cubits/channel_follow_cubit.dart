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

  void set(bool? subscribed) => emit(_idle(subscribed));

  Future<void> toggle({required int id}) async {
    final Follow? follow = state;
    if (follow == null || follow.busy) return;

    final bool next = !follow.subscribed;
    final ChannelRemoteData remote = locator<ChannelRemoteData>();

    emit((subscribed: next, busy: true));

    try {
      next ? await remote.subscribe(id: id) : await remote.unsubscribe(id: id);
      emit((subscribed: next, busy: false));
    } catch (_) {
      emit((subscribed: !next, busy: false));
    }
  }
}
