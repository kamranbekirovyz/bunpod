import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// One instance per sign-in button, so busy always means *this* provider.
class SocialSignInCubit extends Cubit<ViewState> {
  SocialSignInCubit(this.provider) : super(const ViewIdle());

  final AuthProvider provider;

  Future<void> signIn() async {
    if (state is ViewBusy) return;

    emit(const ViewBusy());

    try {
      final SocialSignInResult result = await locator<SocialSignInService>()
          .signIn(provider);

      final Tokens tokens = await locator<AuthRemoteData>().socialSignIn(
        provider: result.provider,
        idToken: result.idToken,
      );

      await locator<SecureStorageLocalData>().cacheTokens(tokens);

      if (isClosed) return;

      emit(const ViewReady());
    } on SocialSignInCancelled {
      if (!isClosed) emit(const ViewIdle());
    } catch (error, stackTrace) {
      logarte.log('sign in failed: $error');
      logarte.log('stack trace: $stackTrace');

      if (!isClosed) emit(const ViewFailed());
    }
  }
}
