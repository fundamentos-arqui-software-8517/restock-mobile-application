import 'package:restock/resources/domain/commands/register_batch_command.dart';

/// Request model for registering a batch.
class RegisterBatchRequest {
  const RegisterBatchRequest({
    required this.code,
    required this.currentStock,
    required this.customSupplyId,
    required this.branchId,
    required this.expirationDate,
  });

  final String code;
  final double currentStock;
  final String customSupplyId;
  final String branchId;
  final String expirationDate;

  factory RegisterBatchRequest.fromCommand(RegisterBatchCommand command) {
    return RegisterBatchRequest(
      code: command.code,
      currentStock: command.currentStock,
      customSupplyId: command.customSupplyId,
      branchId: command.branchId,
      expirationDate: command.expirationDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'currentStock': currentStock,
      'customSupplyId': customSupplyId,
      'branchId': branchId,
      'expirationDate': expirationDate,
    };
  }
}
