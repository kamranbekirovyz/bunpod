import 'dart:convert';

import 'package:bunpod/bunpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _lastEpisode = 'last_episode';

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

  Future<bool> clear() {
    return sharedPreferences.clear();
  }
}
