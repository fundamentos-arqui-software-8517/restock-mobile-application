// lib/resources/domain/commands/update_branch_command.dart
import 'package:image_picker/image_picker.dart';

/// A command object for updating an existing branch, containing all necessary information.
class UpdateBranchCommand {
  const UpdateBranchCommand({
    required this.branchId,
    required this.name,
    required this.address,
    required this.regionOrState,
    required this.city,
    required this.country,
    required this.description,
    this.image,
  });

  final String branchId;
  final String name;
  final String address;
  final String regionOrState;
  final String city;
  final String country;
  final String description;
  final XFile? image;
}