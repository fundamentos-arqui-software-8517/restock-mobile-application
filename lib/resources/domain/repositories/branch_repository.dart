import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/commands/register_branch_command.dart';
import 'package:restock/resources/domain/commands/update_branch_status_command.dart';

import '../commands/update_branch_command.dart';

/// Repository for fetching branches related to an account.
abstract class BranchRepository {

  /// Fetches a list of branches associated with the current account.
  Future<List<Branch>> getBranchesByAccountId(String accountId);

  /// Registers a new branch with the given [RegisterBranchCommand].
  Future<Branch> registerBranch(RegisterBranchCommand command);

  /// Updates an existing branch with the given [UpdateBranchCommand].
  Future<Branch> updateBranch(UpdateBranchCommand command);

  /// Fetches a branch by its ID.
  Future<Branch> getBranchById(String branchId);

  /// Updates the status of a branch with the given [UpdateBranchStatusCommand].
  Future<void> updateBranchStatus(UpdateBranchStatusCommand command);
}