/// Event for BranchListBloc
abstract class BranchListEvent {
  const BranchListEvent();
}

/// Event to get branches
class GetBranches extends BranchListEvent {
  const GetBranches();
}