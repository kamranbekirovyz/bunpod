Future<List<R>> mapWithLimit<T, R>(
  List<T> items,
  int limit,
  Future<R> Function(T item) call,
) async {
  final List<R?> results = List<R?>.filled(items.length, null);
  int next = 0;

  Future<void> worker() async {
    while (next < items.length) {
      final int index = next++;
      results[index] = await call(items[index]);
    }
  }

  await Future.wait([
    for (int i = 0; i < limit && i < items.length; i++) worker(),
  ]);

  return results.cast<R>();
}
