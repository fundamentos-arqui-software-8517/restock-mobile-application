sealed class BatchListEvent {
  const BatchListEvent();
}

class BatchListStarted extends BatchListEvent {
  const BatchListStarted();
}

class BatchSearchChanged extends BatchListEvent {
  const BatchSearchChanged(this.query);

  final String query;
}

class BatchStockFilterChanged extends BatchListEvent {
  const BatchStockFilterChanged(this.filter);

  final BatchStockFilter filter;
}

class BatchCategoryFilterChanged extends BatchListEvent {
  const BatchCategoryFilterChanged(this.categoryKey);

  final String? categoryKey;
}

enum BatchStockFilter { any, low, available }
