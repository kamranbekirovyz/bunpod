import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreCategoriesCubit extends Cubit<List<Category>?> {
  ExploreCategoriesCubit() : super(null);

  Future<void> load() async {
    if (state != null) return;

    emit(await locator<ExploreRemoteData>().categories());
  }
}
