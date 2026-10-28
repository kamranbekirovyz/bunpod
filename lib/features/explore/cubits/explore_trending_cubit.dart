import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreTrendingCubit extends Cubit<List<ChannelPreview>?> {
  ExploreTrendingCubit() : super(null);

  int? _categoryId;

  Future<void> load({int? categoryId}) async {
    _categoryId = categoryId;
    emit(null);

    final List<ChannelPreview> shows = await locator<ExploreRemoteData>()
        .trending(categoryId: categoryId);

    if (categoryId == _categoryId) emit(shows);
  }
}
