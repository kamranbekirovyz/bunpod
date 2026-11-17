import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelCubit extends Cubit<Channel?> {
  ChannelCubit() : super(null);

  Future<void> load({int? id, int? appleId}) async {
    final PodcastIndexRemoteData podcastIndex =
        locator<PodcastIndexRemoteData>();

    if (id != null) {
      emit(await podcastIndex.byFeedId(id));
    } else if (appleId != null) {
      emit(await podcastIndex.byItunesId(appleId));
    }
  }
}
