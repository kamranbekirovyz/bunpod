import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutCubit extends Cubit<ViewState> {
  LogoutCubit() : super(const ViewIdle());

  Future<void> logout() async {
    emit(const ViewBusy());

    final String refreshToken =
        (await locator<SecureStorageLocalData>().refreshToken)!;

    await locator<AuthRemoteData>().logout(refreshToken);

    await signOut();

    emit(const ViewReady());
  }
}
