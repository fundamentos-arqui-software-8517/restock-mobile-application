import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class BranchDetailState {
  const BranchDetailState({
    this.status = Status.initial,
    this.branch,
    this.errorMessage,
  });

  final Status status;
  final Branch? branch;
  final String? errorMessage;

  BranchDetailState copyWith({
    Status? status,
    Branch? branch,
    String? errorMessage,
  }) => BranchDetailState(
    status: status ?? this.status,
    branch: branch ?? this.branch,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}