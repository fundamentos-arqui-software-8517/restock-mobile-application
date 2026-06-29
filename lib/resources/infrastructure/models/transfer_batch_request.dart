import 'package:restock/resources/domain/commands/transfer_batch_command.dart';

/// This file defines the [TransferBatchRequest] class, which represents a request to transfer a batch of items from one branch to another.
class TransferBatchRequest {

  /// Constructs a [TransferBatchRequest] with the given parameters.
  const TransferBatchRequest({
    required this.targetBranchId,
    required this.quantity,
    required this.unitMeasurement,
    required this.reason,
  });

  /// The unique identifier of the target branch to which the batch will be transferred.
  final String targetBranchId;

  /// The quantity of items to be transferred from the batch.
  final double quantity;

  /// The unit of measurement for the quantity being transferred (e.g., pieces, kilograms, liters).
  final String unitMeasurement;

  /// The reason for transferring the batch, which can be used for auditing and tracking purposes.
  final String reason;

  /// Factory constructor that creates a [TransferBatchRequest] instance from a [TransferBatchCommand]. This allows for easy conversion from the command object, which is typically used in the domain layer, to the request object, which is used in the infrastructure layer for making API calls.
  factory TransferBatchRequest.fromCommand(TransferBatchCommand command) {
    return TransferBatchRequest(
      targetBranchId: command.targetBranchId,
      quantity: command.quantity,
      unitMeasurement: command.unitMeasurement,
      reason: command.reason,
    );
  }

  /// Converts the [TransferBatchRequest] instance into a JSON-compatible map, which can be used for serialization when sending the request to an API endpoint.
  Map<String, dynamic> toJson() {
    return {
      'targetBranchId': targetBranchId,
      'quantity': quantity,
      'unitMeasurement': unitMeasurement,
      'reason': reason,
    };
  }
}