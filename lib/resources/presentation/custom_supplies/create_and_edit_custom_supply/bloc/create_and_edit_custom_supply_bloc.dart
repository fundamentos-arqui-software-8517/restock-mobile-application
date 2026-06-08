import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

import 'create_and_edit_custom_supply_event.dart';
import 'create_and_edit_custom_supply_state.dart';

class CreateCustomSupplyBloc
    extends Bloc<CreateCustomSupplyEvent, CreateCustomSupplyState> {
  CreateCustomSupplyBloc({
    required this.customSupplyFacadeService,
    CustomSupply? customSupply,
  }) : super(_initialState(customSupply)) {
    on<CreateCustomSupplyNameChanged>(
      (event, emit) => emit(state.copyWith(name: event.name)),
    );
    on<CreateCustomSupplySupplyChanged>(
      (event, emit) => emit(
        state.copyWith(
          supply: event.supply,
          supplyId: event.supply.supplyId,
          category: event.supply.category,
        ),
      ),
    );
    on<CreateCustomSupplyMinimumStockChanged>(
      (event, emit) => emit(state.copyWith(minimumStock: event.minimumStock)),
    );
    on<CreateCustomSupplyMaximumStockChanged>(
      (event, emit) => emit(state.copyWith(maximumStock: event.maximumStock)),
    );
    on<CreateCustomSupplyUnitPriceChanged>(
      (event, emit) => emit(state.copyWith(unitPrice: event.unitPrice)),
    );
    on<CreateCustomSupplyCurrencyChanged>(
      (event, emit) => emit(state.copyWith(currency: event.currency)),
    );
    on<CreateCustomSupplyUnitChanged>(
      (event, emit) => emit(state.copyWith(unit: event.unit)),
    );
    on<CreateCustomSupplyDescriptionChanged>(
      (event, emit) => emit(state.copyWith(description: event.description)),
    );
    on<CreateCustomSupplyImageChanged>(
      (event, emit) => emit(state.copyWith(image: event.image)),
    );
    on<CreateCustomSupplySubmitted>(_onSubmitted);
  }

  final CustomSupplyFacadeService customSupplyFacadeService;

  Future<void> _onSubmitted(
    CreateCustomSupplySubmitted event,
    Emitter<CreateCustomSupplyState> emit,
  ) async {
    if (state.status == Status.loading) return;
    if (!state.isValid) return;

    emit(state.copyWith(status: Status.loading));
    try {
      if (state.isEditing) {
        await customSupplyFacadeService.updateCustomSupply(
          customSupplyId: state.customSupplyId!,
          supplyId: state.supplyId,
          name: state.name,
          description: state.description,
          unitPriceAmount: state.unitPrice,
          unitPriceCurrencyCode: state.currency,
          minimumStock: double.parse(state.minimumStock),
          maximumStock: double.parse(state.maximumStock),
          unitMeasurement: state.unitMeasurement,
          unitMeasurementAbbreviation: state.unit,
          picture: state.image,
        );
      } else {
        await customSupplyFacadeService.registerCustomSupply(
          supplyId: state.supplyId,
          name: state.name,
          description: state.description,
          unitPriceAmount: state.unitPrice,
          unitPriceCurrencyCode: state.currency,
          minimumStock: double.parse(state.minimumStock),
          maximumStock: double.parse(state.maximumStock),
          unitMeasurement: state.unitMeasurement,
          unitMeasurementAbbreviation: state.unit,
          picture: state.image,
        );
      }

      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }
}

CreateCustomSupplyState _initialState(CustomSupply? customSupply) {
  if (customSupply == null) return const CreateCustomSupplyState();

  return CreateCustomSupplyState(
    customSupplyId: customSupply.customSupplyId,
    name: customSupply.name,
    category: customSupply.category,
    supplyId: customSupply.supply.supplyId,
    supply: customSupply.supply,
    minimumStock: _formatNumber(customSupply.minimumStock),
    maximumStock: _formatNumber(customSupply.maximumStock),
    unitPrice: customSupply.unitPriceAmount,
    currency: customSupply.unitPriceCurrencyCode.isEmpty
        ? 'PEN'
        : customSupply.unitPriceCurrencyCode,
    unit: _unitKey(customSupply.unitMeasurementAbbreviation),
    description: customSupply.description,
    pictureUrl: customSupply.pictureUrl,
  );
}

String _formatNumber(double value) {
  final text = value.toStringAsFixed(2);
  return text.endsWith('.00') ? text.substring(0, text.length - 3) : text;
}

String _unitKey(String unit) {
  return switch (unit.toLowerCase()) {
    'kilograms' || 'kilogram' || 'kg' => 'kg',
    'liters' || 'liter' || 'l' => 'l',
    'dozen' => 'dozen',
    'grams' || 'gram' || 'g' => 'g',
    'units' || 'unit' => 'unit',
    _ => 'kg',
  };
}
