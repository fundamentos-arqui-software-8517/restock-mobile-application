import 'package:image_picker/image_picker.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// State for the [CreateAndEditBranchBloc].
class CreateAndEditBranchState {
  const CreateAndEditBranchState({
    this.status = Status.initial,
    this.branchId,
    this.name = '',
    this.address = '',
    this.stateOrRegion = '',
    this.city = '',
    this.country = '',
    this.description = '',
    this.image,
    this.errorMessage,
  });

  final Status status;
  final String? branchId;
  final String name;
  final String address;
  final String stateOrRegion;
  final String city;
  final String country;
  final String description;
  final XFile? image;
  final String? errorMessage;

  /// Indicates whether the form is in editing mode (editing an existing branch) or creating mode (creating a new branch). It returns true if the [branchId] is not null, which means we are editing an existing branch.
  bool get isEditing => branchId != null;

  /// Validates the form fields. It returns true if all required fields are not empty, which means the form is valid and can be submitted.
  bool get isValid =>
      name.isNotEmpty &&
      address.isNotEmpty &&
      stateOrRegion.isNotEmpty &&
      city.isNotEmpty &&
      country.isNotEmpty;

  /// Creates a copy of the current state with the given parameters. If a parameter is not provided, it will use the current value from the state. This method is used to update the state in an immutable way when handling events in the bloc.
  CreateAndEditBranchState copyWith({
    Status? status,
    String? branchId,
    String? name,
    String? address,
    String? stateOrRegion,
    String? city,
    String? country,
    String? description,
    XFile? image,
    String? errorMessage,
  }) {
    return CreateAndEditBranchState(
      status: status ?? this.status,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      address: address ?? this.address,
      stateOrRegion: stateOrRegion ?? this.stateOrRegion,
      city: city ?? this.city,
      country: country ?? this.country,
      description: description ?? this.description,
      image: image ?? this.image,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
