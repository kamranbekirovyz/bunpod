import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreSearchCubit extends Cubit<List<ChannelPreview>?> {
  ExploreSearchCubit() : super(null);

  static const Duration _debounce = Duration(milliseconds: 300);

  String _query = '';

  Future<void> search(String query) async {
    _query = query.trim();
    emit(null);

    if (_query.isEmpty) return;

    final String current = _query;

    await Future<void>.delayed(_debounce);
    if (current != _query) return;

    final List<ChannelPreview> results = await locator<ExploreRemoteData>()
        .search(current);

    if (current == _query) emit(results);
  }
}
