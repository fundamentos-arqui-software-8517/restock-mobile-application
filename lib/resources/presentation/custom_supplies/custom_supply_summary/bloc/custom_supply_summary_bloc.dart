import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_summary/bloc/custom_supply_summary_event.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_summary/bloc/custom_supply_summary_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class CustomSupplySummaryBloc
    extends Bloc<CustomSupplySummaryEvent, CustomSupplySummaryState> {
  CustomSupplySummaryBloc({required this.customSupplyFacadeService})
    : super(const CustomSupplySummaryState()) {
    on<CustomSupplySummaryStarted>(_onStarted);
  }

  final CustomSupplyFacadeService customSupplyFacadeService;

  Future<void> _onStarted(
    CustomSupplySummaryStarted event,
    Emitter<CustomSupplySummaryState> emit,
  ) async {
    final initialCustomSupply = event.initialCustomSupply;
    if (initialCustomSupply != null) {
      emit(
        state.copyWith(
          status: Status.success,
          customSupply: initialCustomSupply,
        ),
      );
    } else {
      emit(state.copyWith(status: Status.loading));
    }

    try {
      final customSupply = await customSupplyFacadeService.getCustomSupplyById(
        event.customSupplyId,
      );
      emit(state.copyWith(status: Status.success, customSupply: customSupply));
    } catch (e) {
      if (initialCustomSupply != null) return;
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Failed to load custom supply',
        ),
      );
    }
  }
}
