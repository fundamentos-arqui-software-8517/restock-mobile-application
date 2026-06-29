import 'package:restock/resources/domain/commands/register_batch_command.dart';
import 'package:restock/resources/domain/commands/transfer_batch_command.dart';
import 'package:restock/resources/domain/commands/update_batch_command.dart';
import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/domain/repositories/batch_repository.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

class BatchFacadeService {
  const BatchFacadeService({
    required this.batchRepository,
    required this.branchFacadeService,
    required this.tokenStorage,
  });

  final BatchRepository batchRepository;
  final BranchFacadeService branchFacadeService;

  final TokenStorage tokenStorage;

  Future<List<Batch>> getBatchesByBranchId({
    required String branchId,
    String? customSupplyId,
  }) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }
      return await batchRepository.getBatchesByBranchId(
        accountId: accountId,
        branchId: branchId,
        customSupplyId: customSupplyId,
      );
    } catch (e) {
      throw Exception('Failed to fetch batches by branch: $e');
    }
  }

  Future<List<Batch>> getBatchesForActiveBranch({
    String? customSupplyId,
  }) async {
    try {
      final branchId = await _resolveActiveBranchId();

      return await getBatchesByBranchId(
        branchId: branchId,
        customSupplyId: customSupplyId,
      );
    } catch (e) {
      throw Exception('Failed to fetch batches for active branch: $e');
    }
  }

  Future<Batch> registerBatch({
    required String code,
    required double currentStock,
    required String customSupplyId,
    String? branchId,
    required String expirationDate,
  }) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }
      final selectedBranchId = branchId ?? await _resolveActiveBranchId();

      final command = RegisterBatchCommand(
        accountId: accountId,
        code: code,
        currentStock: currentStock,
        customSupplyId: customSupplyId,
        branchId: selectedBranchId,
        expirationDate: expirationDate,
      );

      return await batchRepository.registerBatch(command);
    } catch (e) {
      throw Exception('Failed to register batch: $e');
    }
  }

  Future<Batch> updateBatch({
    required String batchId,
    required String code,
    required double currentStock,
    required String customSupplyId,
    required String branchId,
    required String expirationDate,
  }) async {
    try {
      final command = UpdateBatchCommand(
        batchId: batchId,
        code: code,
        currentStock: currentStock,
        customSupplyId: customSupplyId,
        branchId: branchId,
        expirationDate: expirationDate,
      );

      return await batchRepository.updateBatch(command);
    } catch (e) {
      throw Exception('Failed to update batch: $e');
    }
  }

  /// Transfers a batch of items from one branch to another.
  /// This method takes the batch identifier, target branch identifier, quantity to be transferred, unit of measurement, and the reason for the transfer as parameters. It constructs a [TransferBatchCommand] with the provided information and calls the [batchRepository] to perform the transfer operation.
  /// If any error occurs during the transfer process, it catches the exception and throws a new exception with a descriptive error message.
  Future<Batch> transferBatch({
    required String batchId,
    required String targetBranchId,
    required double quantity,
    required String unitMeasurement,
    required String reason,
  }) async {
    try {
      final command = TransferBatchCommand(
          batchId: batchId,
          targetBranchId: targetBranchId,
          quantity: quantity,
          unitMeasurement: unitMeasurement,
          reason: reason
      );

      return await batchRepository.transferBatch(command);
    } catch (e) {
      throw Exception('Failed to transfer batch: $e');
    }
  }

  Future<String> _resolveActiveBranchId() async {
    final cachedBranchId = await tokenStorage.readBranchId();
    if (cachedBranchId != null && cachedBranchId.isNotEmpty) {
      return cachedBranchId;
    }

    final branches = await branchFacadeService.getBranchesByAccountId();
    final resolvedBranchId = await branchFacadeService.resolveActiveBranchId(
      branches,
    );

    if (resolvedBranchId == null || resolvedBranchId.isEmpty) {
      throw Exception('Active branch ID not found');
    }

    return resolvedBranchId;
  }
}
