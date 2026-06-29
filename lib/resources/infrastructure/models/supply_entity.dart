import 'package:restock/resources/domain/entities/supply.dart';
import 'package:restock/resources/infrastructure/repositories/constants/resource_database_constants.dart';

/// Represents a supply entity in the application, which corresponds to a supply record in the database.
class SupplyEntity {
  const SupplyEntity({
    required this.supplyId,
    required this.name,
    required this.description,
    required this.category,
    required this.isPerishable,
    this.isCatalog = true,
  });

  final String supplyId;
  final String name;
  final String description;
  final String category;
  final bool isPerishable;
  final bool isCatalog;

  /// Creates a SupplyEntity instance from a map of key-value pairs, typically retrieved from the database.
  factory SupplyEntity.fromMap(Map<String, dynamic> map) {
    return SupplyEntity(
      supplyId: map[ResourceDatabaseConstants.supplyId] as String,
      name: map[ResourceDatabaseConstants.supplyName] as String,
      description: map[ResourceDatabaseConstants.supplyDescription] as String,
      category: map[ResourceDatabaseConstants.supplyCategory] as String,
      isPerishable: map[ResourceDatabaseConstants.supplyIsPerishable] == 1,
      isCatalog: map[ResourceDatabaseConstants.supplyIsCatalog] == 1,
    );
  }

  /// Converts the SupplyEntity instance into a map of key-value pairs, suitable for inserting or updating records in the database.
  Map<String, dynamic> toMap() {
    return {
      ResourceDatabaseConstants.supplyId: supplyId,
      ResourceDatabaseConstants.supplyName: name,
      ResourceDatabaseConstants.supplyDescription: description,
      ResourceDatabaseConstants.supplyCategory: category,
      ResourceDatabaseConstants.supplyIsPerishable: isPerishable ? 1 : 0,
      ResourceDatabaseConstants.supplyIsCatalog: isCatalog ? 1 : 0,
    };
  }

  /// Creates a SupplyEntity instance from a Supply domain entity, allowing for conversion between the domain and data layers.
  factory SupplyEntity.fromDomain(Supply supply) {
    return SupplyEntity(
      supplyId: supply.supplyId,
      name: supply.name,
      description: supply.description,
      category: supply.category,
      isPerishable: supply.isPerishable,
    );
  }

  /// Converts the SupplyEntity instance into a Supply domain entity, allowing for conversion between the data and domain layers.
  Supply toDomain() {
    return Supply(
      supplyId: supplyId,
      name: name,
      description: description,
      category: category,
      isPerishable: isPerishable,
    );
  }
}
