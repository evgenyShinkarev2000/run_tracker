import 'package:flutter/foundation.dart';

class ManualValueNotifier<T> extends ValueListenable<T> with ChangeNotifier {
  @override
  T get value => _value;
  set value(T newValue) => _value = newValue;
  T _value;

  ManualValueNotifier(this._value) {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
