
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/entities/address.dart';
import 'package:restock/shared/infrastructure/constants/database_constants.dart';

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

  factory BranchEntity.fromMap(Map<String, dynamic> map) {
    return BranchEntity(
      branchId: map[DatabaseConstants.branchId],
      accountId: map[DatabaseConstants.branchAccountId],
      name: map[DatabaseConstants.branchName],
      address: map[DatabaseConstants.branchAddress],
      city: map[DatabaseConstants.branchCity],
      stateOrRegion: map[DatabaseConstants.branchStateOrRegion],
      country: map[DatabaseConstants.branchCountry],
      imageUrl: map[DatabaseConstants.branchImageUrl],
      status: map[DatabaseConstants.branchStatus],
      description: map[DatabaseConstants.branchDescription],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.branchId: branchId,
      DatabaseConstants.branchAccountId: accountId,
      DatabaseConstants.branchName: name,
      DatabaseConstants.branchAddress: address,
      DatabaseConstants.branchCity: city,
      DatabaseConstants.branchStateOrRegion: stateOrRegion,
      DatabaseConstants.branchCountry: country,
      DatabaseConstants.branchImageUrl: imageUrl,
      DatabaseConstants.branchStatus: status,
      DatabaseConstants.branchDescription: description,
    };
  }

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