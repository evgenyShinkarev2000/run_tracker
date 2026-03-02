abstract class OptionalValue<T> {
  T? get value;
  bool get hasValue;

  factory OptionalValue.empty() => const _Empty();
  factory OptionalValue.from(T value) => _Present(value);
}

class _Present<T> implements OptionalValue<T> {
  @override
  bool get hasValue => true;

  @override
  T? get value => _value;
  final T _value;

  _Present(T value) : _value = value;
}

class _Empty<T> implements OptionalValue<T> {
  @override
  bool get hasValue => false;

  @override
  T? get value => null;

  const _Empty();
}
