import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class FollowPicksCubit extends Cubit<bool?> {
  FollowPicksCubit() : super(false);

  final _picked = BehaviorSubject<Set<int>>.seeded(<int>{});

  Stream<Set<int>> get picked$ => _picked.stream;

  Set<int> get picked => _picked.value;

  void setPicked(Set<int> picked) {
    _picked.add(picked);
  }

  @override
  Future<void> close() {
    _picked.close();
    return super.close();
  }

  Future<void> follow() async {
    emit(null);

    await locator<OnboardingRemoteData>().subscribeMany(picked.toList());

    emit(true);
  }

  void toggle(int appleId) {
    final Set<int> next = {...picked};
    if (!next.remove(appleId)) next.add(appleId);
    setPicked(next);
  }
}
