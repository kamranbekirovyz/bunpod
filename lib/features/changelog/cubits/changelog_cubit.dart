import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ChangelogCubit extends Cubit<Changelog?> {
  ChangelogCubit() : super(null);

  String? _currentVersion;

  String? get currentVersion => _currentVersion;

  PreferencesLocalData get _preferences => locator<PreferencesLocalData>();

  Future<void> initialize() async {
    final String current = (await PackageInfo.fromPlatform()).version;
    _currentVersion = current;

    final String? lastSeen = _preferences.lastSeenVersion;

    // First install: nothing to catch up on.
    if (lastSeen == null) {
      await _preferences.cacheLastSeenVersion(current);
      return;
    }

    if (lastSeen == current) return;

    final Changelog? changelog = unseenChangelog(
      lastSeen: lastSeen,
      current: current,
    );

    if (changelog == null) {
      await _preferences.cacheLastSeenVersion(current);
      return;
    }

    emit(changelog);
  }

  Future<void> dismiss() async {
    final String? version = _currentVersion;
    if (version != null) {
      await _preferences.cacheLastSeenVersion(version);
    }

    emit(null);
  }
}
