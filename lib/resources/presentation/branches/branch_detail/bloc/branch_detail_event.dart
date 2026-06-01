abstract class BranchDetailEvent {}

class BranchDetailFetched extends BranchDetailEvent {
  BranchDetailFetched(this.branchId);
  final String branchId;
}