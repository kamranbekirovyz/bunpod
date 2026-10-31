import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Decides the first screen.
class LaunchCubit extends Cubit<LaunchDestination?> {
  LaunchCubit() : super(null);

  Future<void> resolve() async {
    try {
      final bool authenticated =
          await locator<SecureStorageLocalData>().accessToken != null;

      emit(authenticated ? .feed : .welcome);
    } catch (error, stackTrace) {
      // Never leave the gate blank. Welcome lets the user sign in again.
      logarte.log('launch resolve failed: $error');
      logarte.log('stack trace: $stackTrace');

      emit(.welcome);
    }
  }
}
