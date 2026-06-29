/// Command used to register a batch.
class RegisterBatchCommand {
  const RegisterBatchCommand({
    required this.accountId,
    required this.code,
    required this.currentStock,
    required this.customSupplyId,
    required this.branchId,
    required this.expirationDate,
  });

  final String accountId;
  final String code;
  final double currentStock;
  final String customSupplyId;
  final String branchId;
  final String expirationDate;
}
