
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/entities/address.dart';
import 'package:restock/resources/infrastructure/repositories/constants/resource_database_constants.dart';

/// Represents a branch entity in the database.
class BranchEntity {
  const BranchEntity({
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
  });

  final String branchId;
  final String accountId;
  final String name;
  final String address;
  final String city;
  final String stateOrRegion;
  final String country;
  final String imageUrl;
  final String status;
  final String description;

  /// Creates a [BranchEntity] from a map retrieved from the database.
  factory BranchEntity.fromMap(Map<String, dynamic> map) {
    return BranchEntity(
      branchId: map[ResourceDatabaseConstants.branchId],
      accountId: map[ResourceDatabaseConstants.branchAccountId],
      name: map[ResourceDatabaseConstants.branchName],
      address: map[ResourceDatabaseConstants.branchAddress],
      city: map[ResourceDatabaseConstants.branchCity],
      stateOrRegion: map[ResourceDatabaseConstants.branchStateOrRegion],
      country: map[ResourceDatabaseConstants.branchCountry],
      imageUrl: map[ResourceDatabaseConstants.branchImageUrl],
      status: map[ResourceDatabaseConstants.branchStatus],
      description: map[ResourceDatabaseConstants.branchDescription],
    );
  }

  /// Converts the [BranchEntity] to a map for storing in the database.
  Map<String, dynamic> toMap() {
    return {
      ResourceDatabaseConstants.branchId: branchId,
      ResourceDatabaseConstants.branchAccountId: accountId,
      ResourceDatabaseConstants.branchName: name,
      ResourceDatabaseConstants.branchAddress: address,
      ResourceDatabaseConstants.branchCity: city,
      ResourceDatabaseConstants.branchStateOrRegion: stateOrRegion,
      ResourceDatabaseConstants.branchCountry: country,
      ResourceDatabaseConstants.branchImageUrl: imageUrl,
      ResourceDatabaseConstants.branchStatus: status,
      ResourceDatabaseConstants.branchDescription: description,
    };
  }

  /// Creates a [BranchEntity] from a [Branch] domain model and an account ID.
  factory BranchEntity.fromDomain(Branch branch, String accountId) {
    return BranchEntity(
      branchId: branch.branchId,
      accountId: accountId,
      name: branch.name,
      address: branch.address.address,
      city: branch.address.city,
      stateOrRegion: branch.address.regionOrState,
      country: branch.address.country,
      imageUrl: branch.imageUrl,
      status: branch.status,
      description: branch.description,
    );
  }

  /// Converts the [BranchEntity] to a [Branch] domain model.
  Branch toDomain() {
    return Branch(
      branchId: branchId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      status: status,
      address: Address(
        address: address,
        city: city,
        regionOrState: stateOrRegion,
        country: country,
      ),
    );
  }
}