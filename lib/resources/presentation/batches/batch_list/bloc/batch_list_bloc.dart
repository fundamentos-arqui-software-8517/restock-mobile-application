import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/batch_facade_service.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_event.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class BatchListBloc extends Bloc<BatchListEvent, BatchListState> {
  BatchListBloc({
    required this.batchFacadeService,
    required this.customSupplyFacadeService,
  }) : super(const BatchListState()) {
    on<BatchListStarted>(_onStarted);
    on<BatchSearchChanged>(_onSearchChanged);
    on<BatchStockFilterChanged>(_onStockFilterChanged);
    on<BatchCategoryFilterChanged>(_onCategoryFilterChanged);
  }

  final BatchFacadeService batchFacadeService;
  final CustomSupplyFacadeService customSupplyFacadeService;

  Future<void> _onStarted(
    BatchListStarted event,
    Emitter<BatchListState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final batches = await batchFacadeService.getBatchesForActiveBranch();
      final customSupplyNamesById = await _loadCustomSupplyNamesById();
      emit(
        state.copyWith(
          status: Status.success,
          batches: batches,
          customSupplyNamesById: customSupplyNamesById,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  Future<Map<String, String>> _loadCustomSupplyNamesById() async {
    try {
      final customSupplies = await customSupplyFacadeService
          .getCustomSuppliesByBranchId();
      return {
        for (final customSupply in customSupplies)
          customSupply.customSupplyId: customSupply.name,
      };
    } catch (_) {
      return const {};
    }
  }

  void _onSearchChanged(
    BatchSearchChanged event,
    Emitter<BatchListState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onStockFilterChanged(
    BatchStockFilterChanged event,
    Emitter<BatchListState> emit,
  ) {
    emit(state.copyWith(stockFilter: event.filter));
  }

  void _onCategoryFilterChanged(
    BatchCategoryFilterChanged event,
    Emitter<BatchListState> emit,
  ) {
    emit(
      state.copyWith(
        categoryFilterKey: event.categoryKey,
        clearCategoryFilter: event.categoryKey == null,
      ),
    );
  }
}
