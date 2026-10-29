import 'package:bunpod/bunpod.dart';

class PlaybackRemoteData {
  const PlaybackRemoteData();

  Future<void> saveProgress({
    required int id,
    required int position,
    bool? completed,
  }) async {
    await RestfulEndpoints.saveProgress(
      id: id,
      position: position,
      completed: completed,
    ).send<void>();
  }
}
