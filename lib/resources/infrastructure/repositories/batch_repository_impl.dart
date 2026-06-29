import 'package:restock/resources/domain/commands/register_batch_command.dart';
import 'package:restock/resources/domain/commands/transfer_batch_command.dart';
import 'package:restock/resources/domain/commands/update_batch_command.dart';
import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/domain/repositories/batch_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/batch_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/models/register_batch_request.dart';
import 'package:restock/resources/infrastructure/models/transfer_batch_request.dart';
import 'package:restock/resources/infrastructure/models/update_batch_request.dart';

class BatchRepositoryImpl implements BatchRepository {
  const BatchRepositoryImpl({required this.remoteDataProvider});

  final BatchRemoteDataProvider remoteDataProvider;

  @override
  Future<List<Batch>> getBatchesByBranchId({
    required String accountId,
    required String branchId,
    String? customSupplyId,
  }) async {
    try {
      final response = await remoteDataProvider.getBatchesByBranchId(
        accountId: accountId,
        branchId: branchId,
        customSupplyId: customSupplyId,
      );
      return response.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get batches by branch: $e');
    }
  }

  @override
  Future<Batch> registerBatch(RegisterBatchCommand command) async {
    try {
      final request = RegisterBatchRequest.fromCommand(command);
      final response = await remoteDataProvider.registerBatch(
        request,
        command.accountId,
      );
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to register batch: $e');
    }
  }

  @override
  Future<Batch> updateBatch(UpdateBatchCommand command) async {
    try {
      final request = UpdateBatchRequest.fromCommand(command);
      final response = await remoteDataProvider.updateBatch(
        request,
        command.batchId,
      );
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to update batch: $e');
    }
  }

  /// Transfers a batch to another branch.
  /// The [TransferBatchCommand] contains the necessary information to perform the transfer,
  @override
  Future<Batch> transferBatch(TransferBatchCommand command) async {
    try {
      final request = TransferBatchRequest.fromCommand(command);
      final response = await remoteDataProvider.transferBatch(
          request,
          command.batchId,
      );

      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to transfer batch: $e');
    }
  }
}
