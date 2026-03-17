final class SortDirection {
  static const SortDirection Ascending = SortDirection._("Ascending");
  static const SortDirection Descending = SortDirection._("Descending");

  final String _display;

  const SortDirection._(this._display);

  @override
  String toString() {
    return _display;
  }
}
