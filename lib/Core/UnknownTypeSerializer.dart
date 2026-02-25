class UnknownTypeSerializer {
  static final UnknownTypeSerializer Default = UnknownTypeSerializer();

  final bool includeRuntimeType;

  UnknownTypeSerializer({this.includeRuntimeType = false});

  Object? visit(Object? obj) {
    if (obj == null) {
      return null;
    }

    final map = {"meta": "unknown object", "obj.toString": obj.toString()};
    if (includeRuntimeType) {
      map["obj.runtimeType.toString"] = obj.runtimeType.toString();
    }

    return map;
  }
}
