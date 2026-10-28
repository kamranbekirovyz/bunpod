import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelFollowCubit extends Cubit<bool?> {
  ChannelFollowCubit() : super(null);

  void set(bool? subscribed) => emit(subscribed);

  Future<void> toggle({required int id}) async {
    final bool subscribed = state == true;
    final ChannelRemoteData remote = locator<ChannelRemoteData>();

    emit(!subscribed);

    try {
      subscribed
          ? await remote.unsubscribe(id: id)
          : await remote.subscribe(id: id);
    } catch (_) {
      emit(subscribed);
    }
  }
}
