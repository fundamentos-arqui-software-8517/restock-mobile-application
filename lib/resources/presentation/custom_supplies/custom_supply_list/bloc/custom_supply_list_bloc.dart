import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_event.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class CustomSupplyListBloc
    extends Bloc<CustomSupplyListEvent, CustomSupplyListState> {
  CustomSupplyListBloc({required this.customSupplyFacadeService})
    : super(const CustomSupplyListState()) {
    on<GetCustomSuppliesByBranchId>(_onLoadCustomSupplies);
    on<CustomSupplySearchChanged>(_onSearchChanged);
  }

  final CustomSupplyFacadeService customSupplyFacadeService;

  Future<void> _onLoadCustomSupplies(
    GetCustomSuppliesByBranchId event,
    Emitter<CustomSupplyListState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final customSupplies = await customSupplyFacadeService
          .getCustomSuppliesByBranchId();
      emit(
        state.copyWith(status: Status.success, customSupplies: customSupplies),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: "Failed to load custom supplies",
        ),
      );
    }
  }

  void _onSearchChanged(
    CustomSupplySearchChanged event,
    Emitter<CustomSupplyListState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
