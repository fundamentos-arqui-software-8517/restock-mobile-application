/// Event for BranchListBloc
abstract class BranchListEvent {
  const BranchListEvent();
}

/// Event to get branches
class GetBranches extends BranchListEvent {
  const GetBranches();
}

/// Event to update a branch status in the current list.
class BranchStatusUpdated extends BranchListEvent {
  const BranchStatusUpdated({
    required this.branchId,
    required this.status,
  });

  final String branchId;
  final String status;
}
