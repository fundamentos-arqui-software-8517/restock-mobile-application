import 'package:restock/devices/domain/entities/batch.dart';
import 'package:restock/devices/domain/repositories/batch_repository.dart';
import 'package:restock/devices/infrastructure/data_sources/batch_remote_data_provider.dart';

class BatchRepositoryImpl implements BatchRepository {
  const BatchRepositoryImpl({required this.remoteDataProvider});

  final BatchRemoteDataProvider remoteDataProvider;

  @override
  Future<List<Batch>> getBatchesByAccountId(String accountId) async {
    try {
      final response =
          await remoteDataProvider.getBatchesByAccountId(accountId);
      return response.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get batches: $e');
    }
  }
}
