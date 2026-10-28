import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedCubit extends Cubit<List<Episode>?> {
  FeedCubit() : super(null);

  Future<void> load({int? channelId}) async {
    emit(null);

    emit(await locator<FeedRemoteData>().feed(channelId: channelId));
  }
}
