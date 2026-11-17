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

    final PodcastIndexRemoteData podcastIndex =
        locator<PodcastIndexRemoteData>();
    final List<Channel?> channels = await Future.wait([
      for (final int appleId in picked) podcastIndex.byItunesId(appleId),
    ]);

    await locator<SubscriptionsLocalData>().subscribe(
      channels.nonNulls.toList(),
    );

    emit(true);
  }

  void toggle(int appleId) {
    final Set<int> next = {...picked};
    if (!next.remove(appleId)) next.add(appleId);
    setPicked(next);
  }
}
