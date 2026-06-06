import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// State for the [UpdateBranchStatusBloc].
class UpdateBranchStatusState {
  const UpdateBranchStatusState({
    this.status = Status.initial,
    this.errorMessage,
  });

  final Status status;
  final String? errorMessage;

  /// Creates a copy of the current state with updated values. This method allows you to create a new instance of [UpdateBranchStatusState] with modified properties while keeping the unchanged properties the same. You can provide new values for any of the properties, and if a property is not provided, it will retain its current value from the existing state.
  UpdateBranchStatusState copyWith({
    Status? status,
    String? errorMessage,
  }) {
    return UpdateBranchStatusState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}