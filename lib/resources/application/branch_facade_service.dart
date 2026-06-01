
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/repositories/branch_repository.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

/// Facade service to manage branch-related operations.
class BranchFacadeService {

  /// Constructor for the BranchFacadeService.
  const BranchFacadeService({
    required this.branchRepository,
    required this.tokenStorage,
  });

  /// Repository for managing branch data.
  final BranchRepository branchRepository;
  
  /// Storage for managing authentication tokens and related data.
  final TokenStorage tokenStorage;


  /// Fetches a list of branches associated with the current account ID.
  Future<List<Branch>> getBranchesByAccountId() async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }
      return await branchRepository.getBranchesByAccountId(accountId);
    } catch (e) {
      throw Exception('Failed to fetch branches: $e');
    }
  }
}