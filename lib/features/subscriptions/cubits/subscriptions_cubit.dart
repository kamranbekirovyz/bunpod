import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionsCubit extends Cubit<List<Podcast>?> {
  SubscriptionsCubit() : super(null);

  Future<void> load() async {
    emit(null);

    emit(
      await locator<SubscriptionsRemoteData>().subscriptions(),
    );
  }
}
