part of mappers;

abstract class DataToCoreMapper<In, Out> {
  Out map(In data);
}
