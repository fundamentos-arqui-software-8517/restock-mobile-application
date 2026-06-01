import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/entities/register_branch_command.dart';
import 'package:restock/resources/domain/entities/update_branch_command.dart';

/// Repository for fetching branches related to an account.
abstract class BranchRepository {

  /// Fetches a list of branches associated with the current account.
  Future<List<Branch>> getBranchesByAccountId(String accountId);

  /// Registers a new branch with the given [RegisterBranchCommand].
  Future<Branch> registerBranch(RegisterBranchCommand command);

  /// Updates an existing branch with the given [UpdateBranchCommand].
  Future<Branch> updateBranch(UpdateBranchCommand command);

  // Fetches a branch by its ID.
  Future<Branch> getBranchById(String branchId);
}