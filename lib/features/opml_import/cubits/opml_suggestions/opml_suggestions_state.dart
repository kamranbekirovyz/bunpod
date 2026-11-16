part of 'opml_suggestions_cubit.dart';

class OpmlSuggestionsState {
  const OpmlSuggestionsState({
    this.index = 0,
    this.choosing,
    this.followed = 0,
  });

  final int index;
  final int? choosing;
  final int followed;
}
