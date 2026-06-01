import 'package:restock/resources/domain/entities/branch.dart';

/// Repository for fetching branches related to an account.
abstract class BranchRepository {

  /// Fetches a list of branches associated with the current account.
  Future<List<Branch>> getBranchesByAccountId(String accountId);
}