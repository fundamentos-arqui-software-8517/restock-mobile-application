class StockDiscrepancy {
  const StockDiscrepancy({
    required this.discrepancyId,
    required this.physicalStock,
    required this.systemStock,
    required this.difference,
    required this.riskLevel,
    required this.status,
    required this.isConciliated,
    required this.productId,
    required this.productName,
  });

  final String discrepancyId;
  final double physicalStock;
  final double systemStock;
  final double difference;
  final String riskLevel;
  final String status;
  final bool isConciliated;
  final String productId;
  final String productName;
}
