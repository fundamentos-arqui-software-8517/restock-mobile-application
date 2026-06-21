class CriticalProduct {
  const CriticalProduct({
    required this.productId,
    required this.productName,
    required this.supplyId,
    required this.totalStock,
    required this.minStock,
    required this.maxStock,
    required this.stockDeficit,
    required this.branchName,
    required this.branchId,
    required this.unitMeasurement,
  });

  final String productId;
  final String productName;
  final String supplyId;
  final double totalStock;
  final double minStock;
  final double maxStock;
  final double stockDeficit;
  final String branchName;
  final String branchId;
  final String unitMeasurement;
}
