import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:bunpod/bunpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class PlayerCubit extends Cubit<Playback> {
  PlayerCubit() : super(const Playback()) {
    _subscriptions = [
      _handler.playbackState.listen(_onPlaybackState),
      _handler.seeks.debounceTime(_seekSettle).listen((_) => _save()),
    ];
    _lifecycle = AppLifecycleListener(onHide: _save);
    _timer = Timer.periodic(_saveInterval, (_) {
      if (state.playing) _save();
    });
  }

  static const Duration _saveInterval = Duration(seconds: 30);
  static const Duration _seekSettle = Duration(seconds: 2);

  late final List<StreamSubscription<Object>> _subscriptions;
  late final AppLifecycleListener _lifecycle;
  late final Timer _timer;

  PlayerHandler get _handler => locator<PlayerHandler>();

  Stream<Duration> get position => _handler.positionStream;

  Duration get duration => _handler.duration ?? Duration.zero;

  Future<void> play(Episode episode) async {
    if (episode.id != state.episode?.id) {
      await _save();
      emit(
        Playback(episode: episode, loading: true, positions: state.positions),
      );
      await _handler.load(episode.withPosition(state.positions[episode.id]));
    }

    unawaited(_handler.play());
  }

  Future<void> toggle() {
    return state.playing ? _handler.pause() : _handler.play();
  }

  Future<void> rewind() => _handler.rewind();

  Future<void> fastForward() => _handler.fastForward();

  Future<void> seek(Duration position) => _handler.seek(position);

  void _onPlaybackState(PlaybackState playback) {
    final bool completed =
        playback.processingState == AudioProcessingState.completed;
    final bool playing = playback.playing && !completed;
    final bool started = !state.playing && playing;
    final bool paused = state.playing && !playing;

    emit(
      Playback(
        episode: state.episode,
        positions: state.positions,
        playing: playing,
        loading:
            playback.processingState == AudioProcessingState.loading ||
            playback.processingState == AudioProcessingState.buffering,
      ),
    );

    if (started) _save();
    if (paused) _save(completed: completed);
  }

  Future<void> _save({bool completed = false}) async {
    final Episode? episode = state.episode;
    final int? id = episode?.id;
    if (episode == null || id == null) return;

    final Duration position = _handler.position;

    locator<PreferencesLocalData>()
        .cacheLastEpisode(episode.withPosition(position))
        .ignore();

    emit(
      Playback(
        episode: episode,
        playing: state.playing,
        loading: state.loading,
        positions: {
          ...state.positions,
          id: position,
        },
      ),
    );

    await locator<PlaybackRemoteData>().saveProgress(
      id: id,
      position: position.inSeconds,
      completed: completed ? true : null,
    );
  }

  @override
  Future<void> close() {
    for (final StreamSubscription<Object> subscription in _subscriptions) {
      subscription.cancel();
    }
    _lifecycle.dispose();
    _timer.cancel();
    return super.close();
  }
}
