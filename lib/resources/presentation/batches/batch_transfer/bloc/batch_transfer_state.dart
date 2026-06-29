import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// The BatchTransferState class represents the state of the batch transfer form, including the list of batches and branches, the selected batch and destination branch, the quantity to transfer, the reason for transfer, and any validation errors. It also includes computed properties to determine if the form is loading or valid based on the current state.
class BatchTransferState {
  /// The constructor initializes the state with default values, allowing for optional parameters to be provided when creating an instance of BatchTransferState. This design enables easy state management in a Bloc or Cubit, where the state can be updated based on user interactions and data fetching results.
  const BatchTransferState({
    this.status = Status.initial,
    this.batches = const [],
    this.batchesStatus = Status.initial,
    this.branches = const [],
    this.branchesStatus = Status.initial,
    this.selectedBatch,
    this.destinationBranch,
    this.quantityToTransfer = 0,
    this.reason,
    this.submitted = false,
    this.messageError,
  });

  final Status status;
  final List<Batch> batches;
  final Status batchesStatus;
  final List<Branch> branches;
  final Status branchesStatus;

  final Batch? selectedBatch;
  final Branch? destinationBranch;
  final double quantityToTransfer;
  final String? reason;

  final bool submitted;
  final String? messageError;

  /// The form is loading if the status is loading, which can be used to show a loading indicator while fetching batches or branches.
  bool get isLoading => status == Status.loading;

  /// The form is valid if a batch and a destination branch are selected, and there are no validation errors for the quantity or reason.
  bool get isValid =>
      batchError == null &&
      branchError == null &&
      transferredQuantityError == null &&
      reasonError == null;

  /// The quantity to transfer must be greater than 0 and cannot exceed the current stock of the selected batch.
  String? get transferredQuantityError {
    if (!submitted) return null;
    if (selectedBatch == null) return null;
    if (quantityToTransfer > selectedBatch!.currentStock) {
      return 'Transfer quantity exceeds current stock';
    }
    if (quantityToTransfer <= 0) return 'Enter a valid quantity';
    return null;
  }

  /// The destination branch must be selected for the transfer to be valid.
  String? get branchError {
    if (!submitted) return null;
    if (destinationBranch == null) return 'Select a destination zone';
    return null;
  }

  /// The batch must be selected for the transfer to be valid.
  String? get batchError {
    if (!submitted) return null;
    if (selectedBatch == null) return 'Select a batch stock to transfer';
    return null;
  }

  /// The reason is optional, but if provided, it cannot be empty or just whitespace.
  String? get reasonError {
    if (!submitted) return null;
    if (reason != null && reason!.isNotEmpty && reason!.trim().isEmpty) {
      return 'When provided, reason cannot be empty';
    }
    return null;
  }

  /// The copyWith method allows for creating a new instance of BatchTransferState with updated values while keeping the existing values for any fields that are not provided. This is useful for state management in a Bloc or Cubit, where you want to emit a new state based on the current state with some changes.
  BatchTransferState copyWith({
    Status? status,
    List<Batch>? batches,
    Status? batchesStatus,
    List<Branch>? branches,
    Status? branchesStatus,
    Batch? selectedBatch,
    Branch? destinationBranch,
    double? quantityToTransfer,
    String? reason,
    bool? submitted,
    String? messageError,
  }) {
    return BatchTransferState(
      status: status ?? this.status,
      batches: batches ?? this.batches,
      batchesStatus: batchesStatus ?? this.batchesStatus,
      branches: branches ?? this.branches,
      branchesStatus: branchesStatus ?? this.branchesStatus,
      selectedBatch: selectedBatch ?? this.selectedBatch,
      destinationBranch: destinationBranch ?? this.destinationBranch,
      quantityToTransfer: quantityToTransfer ?? this.quantityToTransfer,
      reason: reason ?? this.reason,
      submitted: submitted ?? this.submitted,
      messageError: messageError ?? this.messageError,
    );
  }
}
