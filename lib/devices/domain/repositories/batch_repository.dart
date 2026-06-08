import '../entities/batch.dart';

abstract class BatchRepository {
  Future<List<Batch>> getBatchesByAccountId(String accountId);
}
