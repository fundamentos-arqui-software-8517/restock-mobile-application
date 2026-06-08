import 'package:restock/resources/domain/entities/supply.dart';

/// Represents a custom supply configured for an account.
class CustomSupply {
  const CustomSupply({
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

  String get category => supply.category;
  String get imageUrl => pictureUrl;
  double get minStock => minimumStock;
  double get maxStock => maximumStock;
  String get unitOfMeasure => unitMeasurementAbbreviation;

  double get unitPrice => double.tryParse(unitPriceAmount) ?? 0;
}
