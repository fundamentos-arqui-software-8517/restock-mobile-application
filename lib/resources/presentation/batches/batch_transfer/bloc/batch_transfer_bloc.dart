import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/batch_facade_service.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/presentation/batches/batch_transfer/bloc/batch_transfer_event.dart';
import 'package:restock/resources/presentation/batches/batch_transfer/bloc/batch_transfer_state.dart';
import 'package:restock/shared/infrastructure/errors/api_error_parser.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// The [BatchTransferBloc] is a Bloc that manages the state of the batch transfer process. It listens to events related to batch transfer and updates the state accordingly. It interacts with the [BatchFacadeService] and [BranchFacadeService] to perform necessary operations for transferring batches between branches.
class BatchTransferBloc extends Bloc<BatchTransferEvent, BatchTransferState> {
  /// The [BatchTransferBloc] is responsible for managing the state of the batch transfer process. It listens to events related to batch transfer and updates the state accordingly. It interacts with the [BatchFacadeService] and [BranchFacadeService] to perform necessary operations for transferring batches between branches.
  BatchTransferBloc({
    required this.branchFacadeService,
    required this.batchFacadeService,
  }) : super(const BatchTransferState()) {
    on<BatchTransferStarted>(_onStarted);
    on<BatchTransferBatchSelectedChanged>(_onBatchSelectedChanged);
    on<BatchTransferDestinationBranchChanged>(_onDestinationBranchChanged);
    on<BatchTransferStockToTransferChanged>(_onStockToTransferChanged);
    on<BatchTransferSubmitted>(_onSubmitted);
  }

  final BatchFacadeService batchFacadeService;
  final BranchFacadeService branchFacadeService;

  /// Fetches the branches and batches for the active branch when the batch transfer process is started.
  /// It updates the state to loading while fetching data, and then updates the state with the fetched branches and batches on success.
  /// If there is an error during fetching, it updates the state with a failure status and an error message.
  FutureOr<void> _onStarted(
    BatchTransferStarted event,
    Emitter<BatchTransferState> emit,
  ) async {
    // Set the status to loading while fetching branches and batches
    emit(
      state.copyWith(
        status: Status.loading,
        branchesStatus: Status.loading,
        batchesStatus: Status.loading,
      ),
    );

    try {
      // Fetch the branches for the account and the active branch ID
      final accountBranches = await branchFacadeService
          .getBranchesByAccountId();
      final activeBranchId = await branchFacadeService.getActiveBranchId();

      // Filter out the active branch from the list of branches to get the available branches for transfer
      final availableBranches = accountBranches
          .where((branch) => branch.branchId != activeBranchId)
          .toList();

      // Fetch the batches for the active branch
      final availableBatches = await batchFacadeService
          .getBatchesForActiveBranch();

      // Update the state with the fetched branches and batches, and set the status to success
      emit(
        state.copyWith(
          status: Status.success,
          batchesStatus: Status.success,
          batches: availableBatches,
          branchesStatus: Status.success,
          branches: availableBranches,
        ),
      );
    } catch (e) {
      // If there is an error during fetching, update the state with a failure status and an error message
      emit(
        state.copyWith(
          branchesStatus: Status.failure,
          batchesStatus: Status.failure,
          messageError: 'Failed to load branches and batches',
        ),
      );
    }
  }

  /// Updates the selected batch in the state when a batch is selected from the list of available batches.
  /// This event is triggered when the user selects a batch to transfer.
  FutureOr<void> _onBatchSelectedChanged(
    BatchTransferBatchSelectedChanged event,
    Emitter<BatchTransferState> emit,
  ) async {
    emit(state.copyWith(selectedBatch: event.selectedBatch));
  }

  /// Updates the destination branch in the state when a branch is selected from the list of available branches.
  /// This event is triggered when the user selects a destination branch for the batch transfer.
  FutureOr<void> _onDestinationBranchChanged(
    BatchTransferDestinationBranchChanged event,
    Emitter<BatchTransferState> emit,
  ) async {
    emit(state.copyWith(destinationBranch: event.destinationBranch));
  }

  /// Updates the quantity to transfer in the state when the user changes the quantity of stock to transfer.
  /// This event is triggered when the user inputs the quantity of stock they want to transfer from the selected batch to the destination branch.
  FutureOr<void> _onStockToTransferChanged(
    BatchTransferStockToTransferChanged event,
    Emitter<BatchTransferState> emit,
  ) async {
    emit(state.copyWith(quantityToTransfer: event.quantity));
  }

  /// Handles the submission of the batch transfer form. It first updates the state to indicate that the form has been submitted, and then checks if the form is valid.
  /// If the form is valid, it sets the status to loading and attempts to perform the batch transfer using the [BatchFacadeService]. If the transfer is successful, it updates the state with a success status. If there is an error during the transfer, it updates the state with a failure status and an error message.
  FutureOr<void> _onSubmitted(
    BatchTransferSubmitted event,
    Emitter<BatchTransferState> emit,
  ) async {
    // Set the submitted flag to true to trigger validation and show any validation errors in the UI
    final submittedState = state.copyWith(submitted: true);
    emit(submittedState);

    // If the form is not valid (e.g., no batch selected, no destination branch selected, invalid quantity), do not proceed with the transfer and return early. The UI can use the validation errors to show appropriate messages to the user.
    if (!submittedState.isValid) return;

    // Set the status to loading while performing the batch transfer
    emit(submittedState.copyWith(status: Status.loading));

    try {
      // Perform the batch transfer using the BatchFacadeService. It requires the batch ID, target branch ID, quantity to transfer, unit of measurement, and an optional reason for the transfer.
      final batchId = submittedState.selectedBatch!.id;
      final unitMeasurement = submittedState.selectedBatch!.unitMeasurement;

      // The reason is optional, but if provided, it cannot be empty or just whitespace. If the reason is not provided, we can pass null to the transferBatch method.
      await batchFacadeService.transferBatch(
        batchId: batchId,
        targetBranchId: submittedState.destinationBranch!.branchId,
        quantity: submittedState.quantityToTransfer,
        unitMeasurement: unitMeasurement,
        reason: submittedState.reason?.trim() ?? '',
      );

      // If the transfer is successful, update the state with a success status. The UI can then show a success message or navigate back to the previous screen.
      emit(submittedState.copyWith(status: Status.success));
    } catch (e) {
      // If there is an error during the transfer, update the state with a failure status and an error message. The UI can use the error message to show an appropriate message to the user.
      emit(
        state.copyWith(
          status: Status.failure,
          messageError: ApiErrorParser.parse(
            e,
            fallback: 'Failed to transfer batch',
          ),
        ),
      );
    }
  }
}
