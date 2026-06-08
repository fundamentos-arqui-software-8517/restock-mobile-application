import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/supply_facade_service.dart';
import 'package:restock/resources/presentation/supplies/supply_list/bloc/supplies_list_event.dart';
import 'package:restock/resources/presentation/supplies/supply_list/bloc/supplies_list_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// Bloc for managing the state of the supplies list in the application.
class SuppliesListBloc extends Bloc<SuppliesListEvent, SuppliesListState> {
  SuppliesListBloc({required this.supplyFacadeService})
    : super(SuppliesListState()) {
    on<GetSupplies>(_onGetSupplies);
  }

  final SupplyFacadeService supplyFacadeService;

  /// Handles the GetSupplies event by fetching the list of supplies from the SupplyFacadeService.
  Future<void> _onGetSupplies(
    GetSupplies event,
    Emitter<SuppliesListState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final supplies = await supplyFacadeService.getSupplies();
      emit(state.copyWith(status: Status.success, supplies: supplies));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: "Failed to load supplies",
        ),
      );
    }
  }
}
