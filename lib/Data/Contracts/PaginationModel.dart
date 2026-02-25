class PaginationModel {
  final int skip;
  final int take;

  const PaginationModel(this.skip, this.take);

  factory PaginationModel.Take(int take) {
    return PaginationModel(0, take);
  }
}
