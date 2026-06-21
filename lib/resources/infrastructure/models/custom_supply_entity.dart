import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/resources/domain/entities/supply.dart';
import 'package:restock/resources/infrastructure/repositories/constants/resource_database_constants.dart';

/// Represents a custom supply entity in the application.
class CustomSupplyEntity {
  const CustomSupplyEntity({
    required this.customSupplyId,
    required this.name,
    required this.description,
    required this.unitPriceAmount,
    required this.unitPriceCurrencyCode,
    required this.minimumStock,
    required this.maximumStock,
    required this.unitMeasurement,
    required this.unitMeasurementAbbreviation,
    required this.pictureUrl,
    required this.picturePublicId,
    required this.accountId,
    required this.supply,
  });

  final String customSupplyId;
  final String name;
  final String description;
  final String unitPriceAmount;
  final String unitPriceCurrencyCode;
  final double minimumStock;
  final double maximumStock;
  final String unitMeasurement;
  final String unitMeasurementAbbreviation;
  final String pictureUrl;
  final String picturePublicId;
  final String accountId;
  final Supply supply;

  factory CustomSupplyEntity.fromMap(Map<String, dynamic> map) {
    return CustomSupplyEntity(
      customSupplyId: map[ResourceDatabaseConstants.customSupplyId] as String,
      name: map[ResourceDatabaseConstants.customSupplyName] as String,
      description: map[ResourceDatabaseConstants.customSupplyDescription] as String,
      unitPriceAmount:
          map[ResourceDatabaseConstants.customSupplyUnitPriceAmount] as String,
      unitPriceCurrencyCode:
          map[ResourceDatabaseConstants.customSupplyUnitPriceCurrencyCode] as String,
      minimumStock: (map[ResourceDatabaseConstants.customSupplyMinimumStock] as num)
          .toDouble(),
      maximumStock: (map[ResourceDatabaseConstants.customSupplyMaximumStock] as num)
          .toDouble(),
      unitMeasurement:
          map[ResourceDatabaseConstants.customSupplyUnitMeasurement] as String,
      unitMeasurementAbbreviation:
          map[ResourceDatabaseConstants.customSupplyUnitMeasurementAbbreviation]
              as String,
      pictureUrl: map[ResourceDatabaseConstants.customSupplyPictureUrl] as String,
      picturePublicId:
          map[ResourceDatabaseConstants.customSupplyPicturePublicId] as String,
      accountId: map[ResourceDatabaseConstants.customSupplyAccountId] as String,
      supply: Supply(
        supplyId: map['supply_id'] as String,
        name: map['supply_name'] as String,
        description: map['supply_description'] as String,
        category: map['supply_category'] as String,
        isPerishable: map['supply_is_perishable'] == 1,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ResourceDatabaseConstants.customSupplyId: customSupplyId,
      ResourceDatabaseConstants.customSupplySupplyId: supply.supplyId,
      ResourceDatabaseConstants.customSupplyName: name,
      ResourceDatabaseConstants.customSupplyDescription: description,
      ResourceDatabaseConstants.customSupplyUnitPriceAmount: unitPriceAmount,
      ResourceDatabaseConstants.customSupplyUnitPriceCurrencyCode:
          unitPriceCurrencyCode,
      ResourceDatabaseConstants.customSupplyMinimumStock: minimumStock,
      ResourceDatabaseConstants.customSupplyMaximumStock: maximumStock,
      ResourceDatabaseConstants.customSupplyUnitMeasurement: unitMeasurement,
      ResourceDatabaseConstants.customSupplyUnitMeasurementAbbreviation:
          unitMeasurementAbbreviation,
      ResourceDatabaseConstants.customSupplyPictureUrl: pictureUrl,
      ResourceDatabaseConstants.customSupplyPicturePublicId: picturePublicId,
      ResourceDatabaseConstants.customSupplyAccountId: accountId,
    };
  }

  factory CustomSupplyEntity.fromDomain(CustomSupply customSupply) {
    return CustomSupplyEntity(
      customSupplyId: customSupply.customSupplyId,
      name: customSupply.name,
      description: customSupply.description,
      unitPriceAmount: customSupply.unitPriceAmount,
      unitPriceCurrencyCode: customSupply.unitPriceCurrencyCode,
      minimumStock: customSupply.minimumStock,
      maximumStock: customSupply.maximumStock,
      unitMeasurement: customSupply.unitMeasurement,
      unitMeasurementAbbreviation: customSupply.unitMeasurementAbbreviation,
      pictureUrl: customSupply.pictureUrl,
      picturePublicId: customSupply.picturePublicId,
      accountId: customSupply.accountId,
      supply: customSupply.supply,
    );
  }

  CustomSupply toDomain() {
    return CustomSupply(
      customSupplyId: customSupplyId,
      name: name,
      description: description,
      unitPriceAmount: unitPriceAmount,
      unitPriceCurrencyCode: unitPriceCurrencyCode,
      minimumStock: minimumStock,
      maximumStock: maximumStock,
      unitMeasurement: unitMeasurement,
      unitMeasurementAbbreviation: unitMeasurementAbbreviation,
      pictureUrl: pictureUrl,
      picturePublicId: picturePublicId,
      accountId: accountId,
      supply: supply,
    );
  }
}
