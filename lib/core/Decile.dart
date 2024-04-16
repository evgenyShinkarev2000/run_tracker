class Decile<T extends Comparable> {
  int? firstIndex;
  int? ninthIndex;

  List<T> process(Iterable<T> items) {
    final sorted = items.toList();
    if (sorted.isEmpty) {
      return List.empty();
    }
    sorted.sort();

    firstIndex = (sorted.length / 10).floor();
    ninthIndex = (sorted.length * 0.9).floor();

    return sorted;
  }
}
