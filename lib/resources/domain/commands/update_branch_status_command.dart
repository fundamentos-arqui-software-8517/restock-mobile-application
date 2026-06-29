/// A command to update the status of a branch.
class UpdateBranchStatusCommand {
  final String status;
  final String branchId;

  /// Creates an instance of [UpdateBranchStatusCommand].
  UpdateBranchStatusCommand({
    required this.status,
    required this.branchId,
  });
}