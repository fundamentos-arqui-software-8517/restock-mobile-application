class UpdateBatchCommand {
  const UpdateBatchCommand({
    required this.batchId,
    required this.code,
    required this.currentStock,
    required this.customSupplyId,
    required this.branchId,
    required this.expirationDate,
  });

  final String batchId;
  final String code;
  final double currentStock;
  final String customSupplyId;
  final String branchId;
  final String expirationDate;
}
