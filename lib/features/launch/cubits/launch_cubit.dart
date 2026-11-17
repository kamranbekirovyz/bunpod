import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Decides the first screen.
class LaunchCubit extends Cubit<LaunchDestination?> {
  LaunchCubit() : super(null);

  // Whatever doesn't move in time moves on the next launch.
  static const Duration _migrationBudget = Duration(seconds: 5);

  Future<void> resolve() async {
    try {
      await locator<LegacySubscriptionsMigration>().run().timeout(
        _migrationBudget,
      );
    } catch (error) {
      logarte.log('legacy subscriptions migration cut short: $error');
    }

    final bool welcomed = locator<PreferencesLocalData>().welcomed;

    emit(welcomed ? .preparing : .welcome);
  }

  void prepared() {
    emit(.feed);
  }
}
