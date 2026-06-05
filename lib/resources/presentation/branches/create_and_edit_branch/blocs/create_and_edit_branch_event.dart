import 'package:image_picker/image_picker.dart';

/// Events for the [CreateAndEditBranchBloc].
abstract class CreateAndEditBranchEvent {
  const CreateAndEditBranchEvent();
}

/// Event when the name of the branch changes.
class CreateAndEditBranchNameChanged extends CreateAndEditBranchEvent {
  const CreateAndEditBranchNameChanged(this.name);
  final String name;
}

/// Event when the address of the branch changes.
class CreateAndEditBranchAddressChanged extends CreateAndEditBranchEvent {
  const CreateAndEditBranchAddressChanged(this.address);
  final String address;
}

/// Event when the state or region of the branch changes.
class CreateAndEditBranchStateOrRegionChanged extends CreateAndEditBranchEvent {
  const CreateAndEditBranchStateOrRegionChanged(this.stateOrRegion);
  final String stateOrRegion;
}

/// Event when the city of the branch changes.
class CreateAndEditBranchCityChanged extends CreateAndEditBranchEvent {
  const CreateAndEditBranchCityChanged(this.city);
  final String city;
}

/// Event when the country of the branch changes.
class CreateAndEditBranchCountryChanged extends CreateAndEditBranchEvent {
  const CreateAndEditBranchCountryChanged(this.country);
  final String country;
}

/// Event when the description of the branch changes.
class CreateAndEditBranchDescriptionChanged extends CreateAndEditBranchEvent {
  const CreateAndEditBranchDescriptionChanged(this.description);
  final String description;
}

/// Event when the image of the branch changes.
class CreateAndEditBranchImageChanged extends CreateAndEditBranchEvent {
  const CreateAndEditBranchImageChanged(this.image);
  final XFile? image;
}

/// Event when the form is submitted.
class CreateAndEditBranchSubmitted extends CreateAndEditBranchEvent {
  const CreateAndEditBranchSubmitted();
}