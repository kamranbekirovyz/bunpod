import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Seed colors by channel id, taken from each channel's cover art.
class ChannelColorsCubit extends Cubit<Map<int, Color>> {
  ChannelColorsCubit() : super(locator<PreferencesLocalData>().channelSeeds);

  final Set<int> _requested = {};

  /// Reads the color from [image] if channel [id] doesn't have one yet.
  void ensure(int id, String image) {
    if (state.containsKey(id) || image.isEmpty) return;
    if (!_requested.add(id)) return;

    _extract(id, image);
  }

  Future<void> _extract(int id, String image) async {
    try {
      final Color seed = await seedColorFromImage(image);
      final Map<int, Color> seeds = {...state, id: seed};

      emit(seeds);

      await locator<PreferencesLocalData>().cacheChannelSeeds(seeds);
    } catch (error) {
      // The channel keeps the fallback color and gets another try next launch.
      logarte.log('channel $id color failed: $error');
    }
  }
}
