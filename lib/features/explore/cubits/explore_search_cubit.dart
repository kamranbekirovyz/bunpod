import 'dart:async';

import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

typedef ExploreSearch = ({
  String query,
  List<ChannelPreview> results,
  bool loading,
});

class ExploreSearchCubit extends Cubit<ExploreSearch> {
  ExploreSearchCubit() : super(_idle) {
    _subscription = _queries
        .map((text) => text.trim())
        .debounce(_wait)
        .distinct()
        .switchMap(_search)
        .listen(emit, onError: (_) => emit(_failed));
  }

  static const ExploreSearch _idle = (query: '', results: [], loading: false);
  static const Duration _delay = Duration(milliseconds: 400);
  static const int _minLength = 2;

  final PublishSubject<String> _queries = PublishSubject<String>();
  late final StreamSubscription<ExploreSearch> _subscription;

  ExploreSearch get _failed {
    return (query: state.query, results: state.results, loading: false);
  }

  void search(String text) => _queries.add(text);

  Stream<void> _wait(String query) {
    if (query.length < _minLength) return Stream<void>.value(null);

    return TimerStream<void>(null, _delay);
  }

  Stream<ExploreSearch> _search(String query) async* {
    if (query.length < _minLength) {
      yield _idle;
      return;
    }

    yield (query: query, results: const [], loading: true);

    final List<ChannelPreview> results = await locator<ExploreRemoteData>()
        .search(query);

    yield (query: query, results: results, loading: false);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await _queries.close();
    return super.close();
  }
}
