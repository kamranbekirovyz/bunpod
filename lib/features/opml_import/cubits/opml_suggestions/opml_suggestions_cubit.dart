import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'opml_suggestions_state.dart';

class OpmlSuggestionsCubit extends Cubit<OpmlSuggestionsState> {
  OpmlSuggestionsCubit() : super(const OpmlSuggestionsState());

  /// False when following failed, so the card stays.
  Future<bool> choose(Channel option) async {
    final int? id = option.id;
    if (id == null || state.choosing != null) return false;

    emit(
      OpmlSuggestionsState(
        index: state.index,
        choosing: id,
        followed: state.followed,
      ),
    );

    try {
      await locator<ChannelRemoteData>().subscribe(id: id);
    } catch (_) {
      emit(
        OpmlSuggestionsState(
          index: state.index,
          followed: state.followed,
        ),
      );

      return false;
    }

    emit(
      OpmlSuggestionsState(
        index: state.index + 1,
        followed: state.followed + 1,
      ),
    );

    return true;
  }

  void skip() {
    if (state.choosing != null) return;

    emit(
      OpmlSuggestionsState(
        index: state.index + 1,
        followed: state.followed,
      ),
    );
  }
}
