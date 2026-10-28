import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedCubit extends Cubit<List<FeedEpisode>?> {
  FeedCubit() : super(null);

  Future<void> load() async {
    emit(null);

    emit(await locator<FeedRemoteData>().feed());
  }
}
