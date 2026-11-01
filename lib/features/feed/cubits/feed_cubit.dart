import 'dart:async';

import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class FeedCubit extends Cubit<Feed?> {
  FeedCubit() : super(null) {
    // switchMap drops the response of a channel the user already left.
    _subscription = _channelId.switchMap(_load).listen(emit);
  }

  static const Duration _refreshTimeout = Duration(seconds: 15);

  late final StreamSubscription<Feed?> _subscription;

  final _channelId = BehaviorSubject<int?>();

  Stream<int?> get channelId$ => _channelId.stream;

  int? get channelId => _channelId.valueOrNull;

  void setChannelId(int? channelId) {
    _channelId.add(channelId);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    _channelId.close();
    return super.close();
  }

  Future<void> refresh() async {
    setChannelId(channelId);

    await stream
        .firstWhere((feed) {
          return feed != null;
        })
        .timeout(
          _refreshTimeout,
          onTimeout: () {
            return state;
          },
        );
  }

  Stream<Feed?> _load(int? channelId) async* {
    yield null;

    final List<Episode> episodes = await locator<FeedRemoteData>().feed(
      channelId: channelId,
    );

    yield Feed(episodes);
  }
}
