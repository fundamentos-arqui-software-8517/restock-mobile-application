class AssignBranchRequest {
  const AssignBranchRequest({required this.branchId});

  final String branchId;

  Map<String, dynamic> toJson() => {'branchId': branchId};
}
