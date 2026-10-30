import 'dart:convert';

import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _lastEpisode = 'last_episode';
const String _themeMode = 'theme_mode';
const String _secureStorageCleared = 'secure_storage_cleared';

class PreferencesLocalData {
  const PreferencesLocalData({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  Episode? get lastEpisode {
    final String? json = sharedPreferences.getString(_lastEpisode);
    if (json == null) return null;

    return Episode.fromJson(jsonDecode(json));
  }

  Future<void> cacheLastEpisode(Episode episode) {
    return sharedPreferences.setString(
      _lastEpisode,
      jsonEncode(episode.toJson()),
    );
  }

  bool get secureStorageCleared {
    return sharedPreferences.getBool(_secureStorageCleared) ?? false;
  }

  Future<void> cacheSecureStorageCleared() {
    return sharedPreferences.setBool(_secureStorageCleared, true);
  }

  ThemeMode get themeMode {
    final String? name = sharedPreferences.getString(_themeMode);

    return ThemeMode.values.asNameMap()[name] ?? .system;
  }

  Future<void> cacheThemeMode(ThemeMode mode) {
    return sharedPreferences.setString(_themeMode, mode.name);
  }

  Future<void> clearUser() async {
    await sharedPreferences.remove(_lastEpisode);
  }
}
