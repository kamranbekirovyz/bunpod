import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowPicksCubit extends Cubit<bool?> {
  FollowPicksCubit() : super(false);

  Future<void> follow(List<int> appleIds) async {
    emit(null);

    await locator<OnboardingRemoteData>().subscribeMany(appleIds);

    emit(true);
  }
}
