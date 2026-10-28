import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrendingCubit extends Cubit<List<TrendingPodcast>?> {
  TrendingCubit() : super(null);

  Future<void> load() async {
    emit(null);

    emit(await locator<OnboardingRemoteData>().trending());
  }
}
