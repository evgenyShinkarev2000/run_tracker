abstract interface class IVariantToValueMapper<TVariant extends Enum, TValue> {
  TValue map(TVariant variant);
}
