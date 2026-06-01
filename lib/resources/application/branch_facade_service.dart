
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/repositories/branch_repository.dart';

/// Facade service to manage branch-related operations.
class BranchFacadeService {

  /// Constructor for the BranchFacadeService.
  const BranchFacadeService({
    required this.branchRepository,
  });

  /// Repository for managing branch data.
  final BranchRepository branchRepository;

  /// Fetches a list of branches associated with the current account ID.
  Future<List<Branch>> getBranchesByAccountId() async {
    try {
      return await branchRepository.getBranchesByAccountId();
    } catch (e) {
      throw Exception('Failed to fetch branches: $e');
    }
  }
}