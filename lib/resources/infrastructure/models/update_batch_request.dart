import 'package:restock/resources/domain/commands/update_batch_command.dart';

class UpdateBatchRequest {
  const UpdateBatchRequest({
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

  factory UpdateBatchRequest.fromCommand(UpdateBatchCommand command) {
    return UpdateBatchRequest(
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
