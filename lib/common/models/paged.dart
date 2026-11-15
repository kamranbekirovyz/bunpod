class Paged<T> {
  const Paged({
    this.items = const [],
    this.loading = false,
    this.ended = false,
  });

  final List<T> items;
  final bool loading;
  final bool ended;

  bool get firstLoad => loading && items.isEmpty;
  bool get loadingMore => loading && items.isNotEmpty;
  bool get canLoadMore => !loading && !ended;
}
