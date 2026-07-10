import 'package:bunpod_flutter/bunpod_flutter.dart';

enum DownloadState { downloading, queued, done }

/// One episode stored on (or on its way to) the device.
class Download {
  const Download({
    required this.episode,
    required this.megabytes,
    this.state = .done,
    this.received = 0,
  });

  final Episode episode;
  final int megabytes;
  final DownloadState state;

  /// Megabytes fetched so far — only meaningful while [state] is downloading.
  final int received;

  double get progress => megabytes == 0 ? 0 : received / megabytes;

  bool get played => episode.progress >= 1;
}

/// Compact file-size label, e.g. `284 MB`, `1.2 GB`.
String sizeLabel(int megabytes) {
  if (megabytes >= 1000) {
    final String gb = (megabytes / 1000)
        .toStringAsFixed(1)
        .replaceAll('.0', '');

    return '$gb GB';
  }

  return '$megabytes MB';
}
