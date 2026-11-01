/// One version's entry in the changelog.
class ChangelogRelease {
  const ChangelogRelease({
    this.description,
    required this.changes,
  });

  final String? description;
  final List<String> changes;
}

/// What the sheet shows: one or more releases folded into a single list.
class Changelog {
  const Changelog({
    required this.version,
    required this.changes,
    this.description,
  });

  final String version;
  final String? description;
  final List<String> changes;
}
