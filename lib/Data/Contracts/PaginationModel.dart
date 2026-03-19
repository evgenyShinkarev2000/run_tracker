class PaginationModel {
  final int skip;
  final int take;

  const PaginationModel(this.skip, this.take)
    : assert(skip >= 0),
      assert(take >= 0);

  factory PaginationModel.takeFirst(int take) {
    return PaginationModel(0, take);
  }

  factory PaginationModel.indexedFromOnePage(int pageSize, int pageIndex) {
    assert(pageIndex > 0);
    assert(pageSize >= 0);
    --pageIndex;

    return PaginationModel(pageSize * pageIndex, pageSize);
  }

  factory PaginationModel.indexedFromZeroPage(int pageSize, int pageIndex) {
    assert(pageSize >= 0);
    assert(pageIndex >= 0);

    return PaginationModel(pageSize * pageIndex, pageSize);
  }
}
