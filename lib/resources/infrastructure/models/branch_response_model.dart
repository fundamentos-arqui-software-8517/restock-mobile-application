import '../../domain/entities/branch.dart';
import '../../domain/entities/address.dart';

/// A model class representing a branch response from the API.
class BranchResponseModel {

  /// The unique identifier for the branch.
  final String branchId;

  /// The account identifier associated with the branch.
  final String accountId;

  /// The branch name.
  final String name;

  /// The branch address.
  final String address;

  /// The city where the branch is located.
  final String city;

  /// The state or region where the branch is located.
  final String stateOrRegion;

  /// The country where the branch is located.
  final String country;

  /// The URL of the branch image.
  final String imageUrl;

  /// The current status of the branch.
  final String status;

  /// The branch description.
  final String description;

  /// The creation date of the branch.
  final String createdAt;

  const BranchResponseModel({
    required this.branchId,
    required this.accountId,
    required this.name,
    required this.address,
    required this.city,
    required this.stateOrRegion,
    required this.country,
    required this.imageUrl,
    required this.status,
    required this.description,
    required this.createdAt,
  });

  /// Creates a [BranchResponseModel] from a JSON map.
  factory BranchResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BranchResponseModel(
      branchId: json['id'],
      accountId: json['accountId'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      stateOrRegion: json['stateOrRegion'],
      country: json['country'],
      imageUrl: json['imageUrl'],
      status: json['status'],
      description: json['description'],
      createdAt: json['createdAt'],
    );
  }

  /// Converts this model into a domain entity.
  Branch toDomain() {
    return Branch(
      branchId: branchId,
      name: name,
      address: Address(
        address: address,
        city: city,
        regionOrState: stateOrRegion,
        country: country,
      ),
      imageUrl: imageUrl,
      status: status,
      description: description,
    );
  }
}