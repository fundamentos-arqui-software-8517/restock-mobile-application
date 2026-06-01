

import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/repositories/branch_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/branch_remote_data_provider.dart';

/// Implementation of the BranchRepository that interacts with the BranchRemoteDataProvider.
class BranchRepositoryImpl implements BranchRepository {

  /// Constructor for BranchRepositoryImpl.
  BranchRepositoryImpl({
    required this.branchRemoteDataProvider,
  });

  /// The remote data provider for fetching branch data.
  final BranchRemoteDataProvider branchRemoteDataProvider;

  /// Fetches a list of branches from the remote data provider.
  @override
  Future<List<Branch>> getBranchesByAccountId(String accountId) async {
    try {
      final branchesResponse =
          await branchRemoteDataProvider.getBranchesByAccountId(accountId);

      return branchesResponse
          .map((response) => response.toDomain())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch branches: $e');
    }
  }
}