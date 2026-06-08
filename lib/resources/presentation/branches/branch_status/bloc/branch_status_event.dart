/// Defines the events for updating the status of a branch. These events are used in the [BranchStatusBloc] to handle user interactions related to changing the status of a branch. The main event is [UpdateBranchStatusSubmitted], which is triggered when the user submits a request to update the branch status, containing the necessary information such as the branch ID and the new status.`
abstract class UpdateBranchStatusEvent {
  const UpdateBranchStatusEvent();
}

/// Event triggered when the user submits a request to update the status of a branch. It contains the branch ID and the new status that the user wants to set for the branch.
class UpdateBranchStatusSubmitted extends UpdateBranchStatusEvent {
  const UpdateBranchStatusSubmitted({
    required this.branchId,
    required this.status,
  });

  final String branchId;
  final String status;
}