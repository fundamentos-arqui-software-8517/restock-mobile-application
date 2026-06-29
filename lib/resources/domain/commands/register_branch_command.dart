import 'package:image_picker/image_picker.dart';

/// A command object for registering a new branch, containing all necessary information.
class RegisterBranchCommand {
  const RegisterBranchCommand({
    required this.accountId,
    required this.name,
    required this.address,
    required this.stateOrRegion,
    required this.city,
    required this.country,
    required this.description,
    this.image,
  });

  final String accountId;
  final String name;
  final String address;
  final String stateOrRegion;
  final String city;
  final String country;
  final String description;
  final XFile? image;
}