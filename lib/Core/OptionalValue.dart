class OptionalValue<T> {
  final T? _value;
  T get value {
    assert(hasValue);

    return _value as T;
  }

  final bool hasValue;

  const OptionalValue.empty() : _value = null, hasValue = false;
  const OptionalValue(this._value) : hasValue = true;
}
