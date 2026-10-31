import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedCubit extends Cubit<Feed?> {
  FeedCubit() : super(null);

  Future<void> load({
    int? channelId,
  }) async {
    emit(null);

    emit(
      Feed(
        await locator<FeedRemoteData>().feed(
          channelId: channelId,
        ),
      ),
    );
  }
}
