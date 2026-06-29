import 'package:restock/resources/domain/commands/transfer_batch_command.dart';

import '../entities/batch.dart';
import '../commands/register_batch_command.dart';
import '../commands/update_batch_command.dart';

/// Abstract repository for managing batches, defining the contract for fetching and registering batches.
abstract class BatchRepository {

  /// Fetches batches for a branch. [customSupplyId] can narrow the result.
  Future<List<Batch>> getBatchesByBranchId({
    required String accountId,
    required String branchId,
    String? customSupplyId,
  });

  /// Registers a new batch using the provided command and returns the registered batch.
  Future<Batch> registerBatch(RegisterBatchCommand command);

  /// Transfers a batch using the provided command and returns the updated batch.
  Future<Batch> transferBatch(TransferBatchCommand command);

  /// Updates an existing batch using the provided command and returns the updated batch.
  Future<Batch> updateBatch(UpdateBatchCommand command);
}
