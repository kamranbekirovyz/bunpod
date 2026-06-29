extension DurationX on Duration {
  /// Compact remaining-time label, e.g. `2h 25m`, `34m`, `12s`.
  String get remainingLabel {
    final int h = inHours;
    final int m = inMinutes.remainder(60);
    if (h > 0) return m > 0 ? '${h}h ${m}m' : '${h}h';
    if (m > 0) return '${m}m';

    return '${inSeconds}s';
  }
}
