import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelEpisodesCubit extends Cubit<List<Episode>?> {
  ChannelEpisodesCubit() : super(null);

  Future<void> load({required int id}) async {
    emit(await locator<ChannelRemoteData>().episodes(id: id));
  }
}
