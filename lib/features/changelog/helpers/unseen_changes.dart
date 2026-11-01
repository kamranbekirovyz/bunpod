import 'package:bunpod/bunpod.dart';
import 'package:pub_semver/pub_semver.dart';

/// Every release after [lastSeen] up to and including [current], folded into
/// one changelog, newest first. Jumping from 1.2.0 to 1.5.0 shows 1.3, 1.4
/// and 1.5. Null when there's nothing new.
Changelog? unseenChangelog({
  required String lastSeen,
  required String current,
}) {
  final Version? lastSeenVersion = _parse(lastSeen);
  final Version? currentVersion = _parse(current);
  if (lastSeenVersion == null || currentVersion == null) return null;

  return _fold(
    version: current,
    releases: _releasesWhere(
      (version) => version > lastSeenVersion && version <= currentVersion,
    ),
  );
}

/// The newest release at or below [current], for reopening the changelog
/// from the menu.
Changelog? latestChangelog({required String current}) {
  final Version? currentVersion = _parse(current);
  if (currentVersion == null) return null;

  final List<(Version, ChangelogRelease)> releases = _releasesWhere(
    (version) => version <= currentVersion,
  );
  if (releases.isEmpty) return null;

  return _fold(version: current, releases: releases.take(1).toList());
}

/// Matching releases, newest first.
List<(Version, ChangelogRelease)> _releasesWhere(
  bool Function(Version version) test,
) {
  return [
    for (final MapEntry(:key, :value) in changelogEntries.entries)
      if (_parse(key) case final Version version when test(version))
        (version, value),
  ]..sort((a, b) => b.$1.compareTo(a.$1));
}

Changelog? _fold({
  required String version,
  required List<(Version, ChangelogRelease)> releases,
}) {
  final List<String> changes = [
    for (final (_, release) in releases) ...release.changes,
  ];
  if (changes.isEmpty) return null;

  return Changelog(
    version: version,
    // The newest release that has something to say up top.
    description: releases
        .map((r) => r.$2.description)
        .firstWhere((d) => d != null && d.isNotEmpty, orElse: () => null),
    changes: changes,
  );
}

Version? _parse(String version) {
  try {
    return Version.parse(version);
  } on FormatException {
    return null;
  }
}
