import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnsubscribedCubit extends Cubit<Set<int>> {
  UnsubscribedCubit() : super(const {});

  Future<void> toggle(int id) async {
    final Set<int> before = state;
    final bool unsubscribe = !before.contains(id);
    final ChannelRemoteData remote = locator<ChannelRemoteData>();

    emit(unsubscribe ? {...before, id} : ({...before}..remove(id)));

    try {
      unsubscribe
          ? await remote.unsubscribe(id: id)
          : await remote.subscribe(id: id);
    } catch (_) {
      emit(before);
    }
  }
}
