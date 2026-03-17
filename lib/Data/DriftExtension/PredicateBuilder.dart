import 'package:drift/drift.dart';

class PredicateBuilder {
  Expression<bool>? get predicate => _predicate;
  Expression<bool>? _predicate;

  PredicateBuilder([this._predicate]);

  PredicateBuilder and(Expression<bool> predicate) {
    _predicate = _predicate == null
        ? predicate
        : Expression.and([_predicate!, predicate]);

    return this;
  }

  PredicateBuilder or(Expression<bool> predicate) {
    _predicate = _predicate == null
        ? predicate
        : Expression.or([_predicate!, predicate]);

    return this;
  }
}
