class RecentSale {
  const RecentSale({
    required this.saleId,
    required this.branchId,
    required this.totalAmount,
    required this.saleDate,
    required this.status,
  });

  final String saleId;
  final String branchId;
  final double totalAmount;
  final DateTime? saleDate;
  final String status;
}
