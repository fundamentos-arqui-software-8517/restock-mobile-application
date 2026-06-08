
/// Model representing the request to update the status of a branch.
class UpdateBranchStatusRequest {
  final String branchId;
  final String status;

  UpdateBranchStatusRequest({
    required this.branchId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'status': status,
    };
  }
}