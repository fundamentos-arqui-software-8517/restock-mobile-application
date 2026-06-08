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
    this.branchStatus = 'active',
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
  final String branchStatus;
  final String? errorMessage;

  /// Indicates whether the form is in editing mode (editing an existing branch) or creating mode (creating a new branch). It returns true if the [branchId] is not null, which means we are editing an existing branch.
  bool get isEditing => branchId != null;

  /// Validates the form fields to determine if the form can be submitted. It checks that all required fields (name, address, stateOrRegion, city, and country) are not empty. If any of these fields are empty, it returns false, indicating that the form is not valid for submission.
  bool get isValid =>
      name.isNotEmpty &&
      address.isNotEmpty &&
      stateOrRegion.isNotEmpty &&
      city.isNotEmpty &&
      country.isNotEmpty;

  /// Creates a copy of the current state with updated values. This method allows you to create a new instance of [CreateAndEditBranchState] with modified properties while keeping the unchanged properties the same. You can provide new values for any of the properties, and if a property is not provided, it will retain its current value from the existing state.
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
    String? branchStatus,
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
      branchStatus: branchStatus ?? this.branchStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
