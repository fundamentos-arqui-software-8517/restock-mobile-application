import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/presentation/custom_supply_list/bloc/custom_supply_list_state.dart';
import 'package:restock/resources/presentation/custom_supply_list/bloc/custom_supply_list_event.dart';
import 'package:restock/resources/application/resource_management_facade_service.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class CustomSupplyListBloc
    extends Bloc<CustomSupplyListEvent, CustomSupplyListState> {
  CustomSupplyListBloc({required this.rmFacadeService})
    : super(CustomSupplyListState()) {
    on<GetCustomSuppliesByBranchId>(_onLoadCustomSupplies);
  }

  final ResourceManagementFacadeService rmFacadeService;

  Future<void> _onLoadCustomSupplies(
    GetCustomSuppliesByBranchId event,
    Emitter<CustomSupplyListState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final customSupplies =
          await rmFacadeService.getCustomSuppliesByBranchId();
      emit(
        state.copyWith(
          status: Status.success,
          customSupplies: customSupplies,
        ),
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
}
