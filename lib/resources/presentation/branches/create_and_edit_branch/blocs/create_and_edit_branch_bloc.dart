import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'create_and_edit_branch_event.dart';
import 'create_and_edit_branch_state.dart';

/// Bloc for creating and editing branches.
class CreateAndEditBranchBloc
    extends Bloc<CreateAndEditBranchEvent, CreateAndEditBranchState> {
  CreateAndEditBranchBloc({required this.branchFacadeService, Branch? branch})
    : super(
        CreateAndEditBranchState(
          branchId: branch?.branchId,
          name: branch?.name ?? '',
          address: branch?.address.address ?? '',
          stateOrRegion: branch?.address.regionOrState ?? '',
          city: branch?.address.city ?? '',
          country: branch?.address.country ?? '',
          description: branch?.description ?? '',
        ),
      ) {
    on<CreateAndEditBranchNameChanged>(_onNameChanged);
    on<CreateAndEditBranchAddressChanged>(_onAddressChanged);
    on<CreateAndEditBranchStateOrRegionChanged>(_onStateOrRegionChanged);
    on<CreateAndEditBranchCityChanged>(_onCityChanged);
    on<CreateAndEditBranchCountryChanged>(_onCountryChanged);
    on<CreateAndEditBranchDescriptionChanged>(_onDescriptionChanged);
    on<CreateAndEditBranchImageChanged>(_onImageChanged);
    on<CreateAndEditBranchSubmitted>(_onSubmitted);
  }

  final BranchFacadeService branchFacadeService;
   
  /// Handler for the name change event. It updates the state with the new name.
  void _onNameChanged(
    CreateAndEditBranchNameChanged event,
    Emitter<CreateAndEditBranchState> emit,
  ) => emit(state.copyWith(name: event.name));

  /// Handler for the address change event. It updates the state with the new address.
  void _onAddressChanged(
    CreateAndEditBranchAddressChanged event,
    Emitter<CreateAndEditBranchState> emit,
  ) => emit(state.copyWith(address: event.address));

  /// Handler for the state or region change event. It updates the state with the new state or region.
  void _onStateOrRegionChanged(
    CreateAndEditBranchStateOrRegionChanged event,
    Emitter<CreateAndEditBranchState> emit,
  ) => emit(state.copyWith(stateOrRegion: event.stateOrRegion));

  /// Handler for the city change event. It updates the state with the new city.
  void _onCityChanged(
    CreateAndEditBranchCityChanged event,
    Emitter<CreateAndEditBranchState> emit,
  ) => emit(state.copyWith(city: event.city));

  /// Handler for the country change event. It updates the state with the new country.
  void _onCountryChanged(
    CreateAndEditBranchCountryChanged event,
    Emitter<CreateAndEditBranchState> emit,
  ) => emit(state.copyWith(country: event.country));
  
  /// Handler for the description change event. It updates the state with the new description.
  void _onDescriptionChanged(
    CreateAndEditBranchDescriptionChanged event,
    Emitter<CreateAndEditBranchState> emit,
  ) => emit(state.copyWith(description: event.description));

  /// Handler for the image change event. It updates the state with the new image file.
  void _onImageChanged(
    CreateAndEditBranchImageChanged event,
    Emitter<CreateAndEditBranchState> emit,
  ) => emit(state.copyWith(image: event.image));

  /// Handler for the form submission event. It validates the form and then calls the appropriate method of the [BranchFacadeService] to create or update the branch.
  Future<void> _onSubmitted(
    CreateAndEditBranchSubmitted event,
    Emitter<CreateAndEditBranchState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: Status.loading));
    try {
      if (state.isEditing) {
        await branchFacadeService.updateBranch(
          branchId: state.branchId!,
          name: state.name,
          address: state.address,
          stateOrRegion: state.stateOrRegion,
          city: state.city,
          country: state.country,
          description: state.description,
          image: state.image,
        );
      } else {
        await branchFacadeService.registerBranch(
          name: state.name,
          address: state.address,
          stateOrRegion: state.stateOrRegion,
          city: state.city,
          country: state.country,
          description: state.description,
          image: state.image,
        );
      }
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }
}
