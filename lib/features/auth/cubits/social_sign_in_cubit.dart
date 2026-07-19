import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// One instance per sign-in button, so busy always means *this* provider.
class SocialSignInCubit extends Cubit<ViewState> {
  SocialSignInCubit(this.provider) : super(const ViewIdle());

  final AuthProvider provider;

  Future<void> signIn() async {
    if (state is ViewBusy) return;

    emit(const ViewBusy());

    // TODO: swap the placeholder beat for the provider SDK + backend exchange.
    await Future<void>.delayed(const Duration(seconds: 3));

    if (isClosed) return;

    emit(const ViewReady());
  }
}
