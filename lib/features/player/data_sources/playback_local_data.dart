import 'package:bunpod/bunpod.dart';
import 'package:drift/drift.dart';

class PlaybackLocalData {
  const PlaybackLocalData();

  AppDatabase get database => locator<AppDatabase>();

  Future<void> saveProgress(
    Episode episode, {
    required Duration position,
    bool? completed,
  }) async {
    final String? feedUrl = episode.feedUrl;
    final String? guid = episode.id;
    if (feedUrl == null || guid == null) return;

    await database
        .into(database.episodeProgress)
        .insertOnConflictUpdate(
          EpisodeProgressCompanion.insert(
            feedUrl: feedUrl,
            guid: guid,
            position: position.inSeconds,
            completed: Value.absentIfNull(completed),
          ),
        );
  }
}
