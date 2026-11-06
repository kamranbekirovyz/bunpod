import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:bunpod/bunpod.dart';
import 'package:just_audio/just_audio.dart';

class PlayerHandler extends BaseAudioHandler with SeekHandler {
  PlayerHandler() {
    _player.playbackEventStream.listen((_) => _broadcast());
    _player.playingStream.listen((_) => _broadcast());
    _player.durationStream.listen(_updateDuration);
    _player.positionStream.listen((_) => position);
    _player.errorStream.listen((_) => _recover());
    _player.processingStateStream
        .where((state) => state == ProcessingState.ready)
        .listen((_) => _retries = 0);
  }

  static const int _maxRetries = 3;

  final AudioPlayer _player = AudioPlayer();

  Duration? _seekTarget;

  Duration _position = Duration.zero;

  Uri? _url;

  int _retries = 0;

  static Future<PlayerHandler> init() async {
    final AudioSession session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    return AudioService.init(
      builder: PlayerHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'app.bunpod.playback',
        androidNotificationChannelName: 'Playback',
        androidNotificationOngoing: true,
        rewindInterval: Duration(seconds: 10),
        fastForwardInterval: Duration(seconds: 10),
      ),
    );
  }

  Stream<Duration> get positionStream => _player.positionStream;

  /// The last position of a loaded episode. After an error the player goes
  /// idle and reports zero, which would overwrite the saved progress. While
  /// loading it isn't settled yet either.
  Duration get position {
    if (_player.processingState case .ready || .buffering || .completed) {
      _position = _player.position;
    }

    return _position;
  }

  Duration? get duration => _player.duration;

  Stream<PositionDiscontinuity> get seeks => _player.positionDiscontinuityStream
      .where((event) => event.reason == PositionDiscontinuityReason.seek);

  Future<void> load(Episode episode) async {
    mediaItem.add(
      MediaItem(
        id: '${episode.id}',
        title: episode.title ?? '',
        artist: episode.channel?.title,
        artUri: Uri.tryParse(episode.cover),
        duration: episode.total > Duration.zero ? episode.total : null,
      ),
    );

    final Duration? start = episode.completed == true ? null : episode.listened;
    _position = start ?? Duration.zero;
    final Uri url = Uri.parse(episode.audioUrl ?? '');
    _url = url;
    _retries = 0;

    await _player.setAudioSource(
      AudioSource.uri(url),
      initialPosition: start,
    );
  }

  /// A dropped stream reloads where it stopped, and keeps playing if it was. After
  /// [_maxRetries] failures in a row it pauses instead.
  Future<void> _recover() async {
    final Uri? url = _url;
    if (url == null) return;

    if (_retries >= _maxRetries) {
      await _player.pause();
      return;
    }

    final bool resume = _player.playing;
    _retries++;
    await Future<void>.delayed(Duration(seconds: _retries));
    if (url != _url) return;

    try {
      await _player.setAudioSource(
        AudioSource.uri(url),
        initialPosition: _position,
      );
      if (resume) await _player.play();
    } catch (error) {
      // The failure lands in the error stream, which retries again.
      logarte.log('playback recovery $_retries failed: $error');
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) {
    _seekTarget = null;

    return _player.seek(position);
  }

  @override
  Future<void> fastForward() {
    return _seekBy(AudioService.config.fastForwardInterval);
  }

  @override
  Future<void> rewind() {
    return _seekBy(-AudioService.config.rewindInterval);
  }

  /// Rapid taps stack on the last requested target rather than on the
  /// player's reported position, which lags while a seek is still settling.
  Future<void> _seekBy(Duration offset) async {
    final Duration base = _seekTarget ?? _player.position;
    final Duration duration = _player.duration ?? Duration.zero;

    Duration target = base + offset;
    if (target < Duration.zero) target = Duration.zero;
    if (duration > Duration.zero && target > duration) target = duration;

    _seekTarget = target;
    await _player.seek(target);

    if (_seekTarget == target) _seekTarget = null;
  }

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  void _updateDuration(Duration? duration) {
    final MediaItem? item = mediaItem.value;

    if (item != null && duration != null) {
      mediaItem.add(item.copyWith(duration: duration));
    }
  }

  void _broadcast() {
    final bool playing = _player.playing;

    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.rewind,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.fastForward,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: switch (_player.processingState) {
          ProcessingState.idle => AudioProcessingState.idle,
          ProcessingState.loading => AudioProcessingState.loading,
          ProcessingState.buffering => AudioProcessingState.buffering,
          ProcessingState.ready => AudioProcessingState.ready,
          ProcessingState.completed => AudioProcessingState.completed,
        },
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ),
    );
  }
}
