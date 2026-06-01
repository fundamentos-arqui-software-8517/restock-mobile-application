import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// State for the BranchListBloc, representing the current status of branch list fetching and the list of branches.
class BranchListState {
  final Status status;
  final List<Branch> branches;
  final String? message;

  /// Creates a new instance of [BranchListState] with the given parameters.
  /// [status] represents the current status of the branch list fetching process, defaulting to [Status.initial].
  /// [branches] is a list of [Branch] objects, defaulting to an empty list.
  /// [message] is an optional string that can hold error messages or other relevant information
  const BranchListState({
    this.status = Status.initial,
    this.branches = const [],
    this.message,
  });

  /// Creates a copy of the current [BranchListState] with the given parameters. If a parameter is not provided, it will default to the current value of that parameter in the state.
  BranchListState copyWith({
    Status? status,
    List<Branch>? branches,
    String? message,
  }) {
    return BranchListState(
      status: status ?? this.status,
      branches: branches ?? this.branches,
      message: message ?? this.message,
    );
  }
}