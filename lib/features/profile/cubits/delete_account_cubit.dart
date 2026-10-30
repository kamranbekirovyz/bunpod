import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAccountCubit extends Cubit<ViewState> {
  DeleteAccountCubit() : super(const ViewIdle());

  Future<void> delete() async {
    emit(const ViewBusy());

    await locator<ProfileRemoteData>().deleteMe();
    await signOut();

    emit(ViewReady());
  }
}
