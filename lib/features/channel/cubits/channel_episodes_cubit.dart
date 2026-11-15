import 'package:bunpod/bunpod.dart';

class ChannelEpisodesCubit extends PagedCubit<Episode> {
  late int _id;

  Future<void> load({required int id}) {
    _id = id;

    return refresh();
  }

  @override
  Future<List<Episode>> fetch({
    required int offset,
    required int limit,
  }) {
    return locator<ChannelRemoteData>().episodes(
      id: _id,
      offset: offset,
      limit: limit,
    );
  }
}
