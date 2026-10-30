import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<User?> {
  UserCubit() : super(null);

  Future<void> load() async {
    emit(
      await locator<ProfileRemoteData>().me(),
    );
  }

  void clear() {
    emit(null);
  }
}
