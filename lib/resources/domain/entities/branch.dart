import 'package:restock/resources/domain/entities/address.dart';

/// Branch entity represents a branch of a company or organization. It contains information about the branch such as its ID, description, image URL, address, and status.
class Branch {
  final String branchId;
  final String name;
  final String description;
  final String imageUrl;
  final Address address;
  final String status;

  /// Constructor for the Branch class. It requires all fields to be provided when creating an instance of Branch.
  Branch({
    required this.branchId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.status,
  });

  /// A computed property that returns the full address of the branch by combining the address and city from the Address entity.
  String get fullAddress =>
    '${address.address}, ${address.city}, ${address.country}';
}
