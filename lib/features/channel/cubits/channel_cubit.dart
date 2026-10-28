import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelCubit extends Cubit<Channel?> {
  ChannelCubit() : super(null);

  Future<void> load({int? id, int? appleId}) async {
    final ChannelRemoteData remote = locator<ChannelRemoteData>();

    if (id != null) {
      emit(await remote.channel(id: id));
    } else if (appleId != null) {
      emit(await remote.channelByAppleId(appleId: appleId));
    }
  }
}
