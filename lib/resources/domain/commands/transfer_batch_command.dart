/// Command to transfer a batch of items from one branch to another.
/// This command encapsulates all the necessary information required to perform the transfer operation, including the batch identifier, target branch identifier, quantity to be transferred, unit of measurement, and the reason for the transfer.
class TransferBatchCommand {

  /// Constructs a [TransferBatchCommand] with the given parameters.
  const TransferBatchCommand({
    required this.batchId,
    required this.targetBranchId,
    required this.quantity,
    required this.unitMeasurement,
    required this.reason,
  });

  /// The unique identifier of the batch to be transferred.
  final String batchId;

  /// The unique identifier of the target branch to which the batch will be transferred.
  final String targetBranchId;

  /// The quantity of items to be transferred from the batch.
  final double quantity;

  /// The unit of measurement for the quantity being transferred (e.g., pieces, kilograms, liters).
  final String unitMeasurement;

  /// The reason for transferring the batch, which can be used for auditing and tracking purposes.
  final String reason;
}