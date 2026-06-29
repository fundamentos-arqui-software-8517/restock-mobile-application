import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/batch_facade_service.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/bloc/create_and_edit_batch_event.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/bloc/create_and_edit_batch_state.dart';
import 'package:restock/shared/infrastructure/errors/api_error_parser.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class CreateAndEditBatchBloc
    extends Bloc<CreateAndEditBatchEvent, CreateAndEditBatchState> {
  CreateAndEditBatchBloc({
    required this.batchFacadeService,
    required this.customSupplyFacadeService,
    Batch? batch,
  }) : _initialBatch = batch,
       super(_initialState(batch)) {
    on<CreateAndEditBatchStarted>(_onStarted);
    on<CreateAndEditBatchSupplyChanged>(_onSupplyChanged);
    on<CreateAndEditBatchCodeChanged>(_onCodeChanged);
    on<CreateAndEditBatchCurrentStockChanged>(_onCurrentStockChanged);
    on<CreateAndEditBatchExpirationDateChanged>(_onExpirationDateChanged);
    on<CreateAndEditBatchSubmitted>(_onSubmitted);
  }

  final BatchFacadeService batchFacadeService;
  final CustomSupplyFacadeService customSupplyFacadeService;
  final Batch? _initialBatch;

  Future<void> _onStarted(
    CreateAndEditBatchStarted event,
    Emitter<CreateAndEditBatchState> emit,
  ) async {
    emit(state.copyWith(suppliesStatus: Status.loading));

    try {
      final customSupplies = await customSupplyFacadeService
          .getCustomSuppliesByBranchId();

      emit(
        state.copyWith(
          suppliesStatus: Status.success,
          customSupplies: customSupplies,
          selectedCustomSupply: _selectedSupply(customSupplies),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          suppliesStatus: Status.failure,
          errorMessage: 'Failed to load supplies',
        ),
      );
    }
  }

  void _onSupplyChanged(
    CreateAndEditBatchSupplyChanged event,
    Emitter<CreateAndEditBatchState> emit,
  ) {
    emit(state.copyWith(selectedCustomSupply: event.customSupply));
  }

  void _onCodeChanged(
    CreateAndEditBatchCodeChanged event,
    Emitter<CreateAndEditBatchState> emit,
  ) {
    emit(state.copyWith(code: event.code));
  }

  void _onCurrentStockChanged(
    CreateAndEditBatchCurrentStockChanged event,
    Emitter<CreateAndEditBatchState> emit,
  ) {
    emit(state.copyWith(currentStock: event.currentStock));
  }

  void _onExpirationDateChanged(
    CreateAndEditBatchExpirationDateChanged event,
    Emitter<CreateAndEditBatchState> emit,
  ) {
    emit(state.copyWith(expirationDate: event.expirationDate));
  }

  Future<void> _onSubmitted(
    CreateAndEditBatchSubmitted event,
    Emitter<CreateAndEditBatchState> emit,
  ) async {
    final submittedState = state.copyWith(submitted: true);
    emit(submittedState);

    if (!submittedState.isValid) return;

    emit(submittedState.copyWith(status: Status.loading));

    try {
      if (submittedState.isEditing) {
        await batchFacadeService.updateBatch(
          batchId: submittedState.batchId!,
          code: submittedState.code.trim(),
          currentStock: double.parse(submittedState.currentStock.trim()),
          customSupplyId: submittedState.selectedCustomSupply!.customSupplyId,
          branchId: submittedState.branchId,
          expirationDate: submittedState.parsedExpirationDate!
              .toIso8601String()
              .substring(0, 10),
        );
      } else {
        await batchFacadeService.registerBatch(
          code: submittedState.code.trim(),
          currentStock: double.parse(submittedState.currentStock.trim()),
          customSupplyId: submittedState.selectedCustomSupply!.customSupplyId,
          expirationDate: submittedState.parsedExpirationDate!
              .toIso8601String()
              .substring(0, 10),
        );
      }

      emit(submittedState.copyWith(status: Status.success));
    } catch (e) {
      emit(
        submittedState.copyWith(
          status: Status.failure,
          errorMessage: ApiErrorParser.parse(
            e,
            fallback: submittedState.isEditing
                ? 'Failed to update batch'
                : 'Failed to register batch',
          ),
        ),
      );
    }
  }

  CustomSupply? _selectedSupply(List<CustomSupply> customSupplies) {
    if (customSupplies.isEmpty) return null;
    if (_initialBatch == null) return customSupplies.first;

    return customSupplies.firstWhere(
      (supply) => supply.customSupplyId == _initialBatch.customSupplyId,
      orElse: () => customSupplies.first,
    );
  }
}

CreateAndEditBatchState _initialState(Batch? batch) {
  if (batch == null) return const CreateAndEditBatchState();

  return CreateAndEditBatchState(
    batchId: batch.id,
    code: batch.code,
    branchId: batch.branchId,
    currentStock: _formatNumber(batch.currentStock),
    expirationDate: _formatDate(batch.expirationDate),
  );
}

String _formatNumber(double value) {
  final text = value.toStringAsFixed(2);
  return text.endsWith('.00') ? text.substring(0, text.length - 3) : text;
}

String _formatDate(DateTime? value) {
  if (value == null) return '';

  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$month/$day/${value.year}';
}
