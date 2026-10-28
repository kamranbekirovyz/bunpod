import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionsCubit extends Cubit<List<Channel>?> {
  SubscriptionsCubit() : super(null);

  Future<void> load() async {
    emit(
      await locator<SubscriptionsRemoteData>().subscriptions(),
    );
  }
}
