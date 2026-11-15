import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PagedCubit<T> extends Cubit<Paged<T>> {
  PagedCubit()
    : super(
        const Paged(
          loading: true,
        ),
      );

  static const int pageSize = 20;

  // drops late answers after a refresh
  int _generation = 0;

  Future<List<T>> fetch({
    required int offset,
    required int limit,
  });

  Future<void> refresh() async {
    final int generation = ++_generation;

    // loader only when empty
    if (state.items.isEmpty) {
      emit(
        const Paged(
          loading: true,
        ),
      );
    }

    try {
      final List<T> page = await fetch(
        offset: 0,
        limit: pageSize,
      );
      if (generation != _generation) return;

      // short page means the end
      emit(
        Paged(
          items: page,
          ended: page.length < pageSize,
        ),
      );
    } catch (error, stackTrace) {
      if (generation != _generation) return;

      logarte.log('refresh failed: $error');
      logarte.log('stack trace: $stackTrace');

      // keep old items on fail
      emit(
        Paged(
          items: state.items,
          ended: state.ended,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    // scroll calls this a lot
    if (!state.canLoadMore) return;

    final int generation = _generation;

    emit(
      Paged(
        items: state.items,
        loading: true,
      ),
    );

    try {
      final List<T> page = await fetch(
        offset: state.items.length,
        limit: pageSize,
      );
      if (generation != _generation) return;

      emit(
        Paged(
          items: [
            ...state.items,
            ...page,
          ],
          ended: page.length < pageSize,
        ),
      );
    } catch (error, stackTrace) {
      if (generation != _generation) return;

      logarte.log('load more failed: $error');
      logarte.log('stack trace: $stackTrace');

      // next scroll retries
      emit(
        Paged(
          items: state.items,
        ),
      );
    }
  }
}
