import 'package:bunpod/bunpod.dart';

class MockPlaybackRemoteData implements PlaybackRemoteData {
  const MockPlaybackRemoteData();

  @override
  Future<void> saveProgress({
    required int id,
    required int position,
    bool? completed,
  }) async {
    await Future<void>.delayed(AppValues.mockDelay);
  }
}
