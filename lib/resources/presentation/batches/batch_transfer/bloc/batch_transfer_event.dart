import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/domain/entities/branch.dart';

/// Events for the BatchTransferBloc, which manages the state of the batch transfer process.
sealed class BatchTransferEvent {
  const BatchTransferEvent();
}

/// Event triggered when the batch transfer process is initiated.
class BatchTransferStarted extends BatchTransferEvent {
  const BatchTransferStarted();
}

/// Event triggered when the user changes the selected batch for transfer.
class BatchTransferBatchSelectedChanged extends BatchTransferEvent {
  const BatchTransferBatchSelectedChanged(this.selectedBatch);

  final Batch selectedBatch;
}

/// Event triggered when the user changes the destination branch for the batch transfer.
class BatchTransferDestinationBranchChanged extends BatchTransferEvent {
  const BatchTransferDestinationBranchChanged(this.destinationBranch);

  final Branch destinationBranch;
}

/// Event triggered when the user changes the quantity of stock to transfer.
class BatchTransferStockToTransferChanged extends BatchTransferEvent {
  const BatchTransferStockToTransferChanged(this.quantity);

  final double quantity;
}

/// Event triggered when the user submits the batch transfer form.
class BatchTransferSubmitted extends BatchTransferEvent {
  const BatchTransferSubmitted();
}