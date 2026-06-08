import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/resources/infrastructure/models/supply_response_model.dart';

/// Response model for `/api/v1/custom-supplies/{customSupplyId}`.
class CustomSupplyResponseModel {
  const CustomSupplyResponseModel({
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
  final SupplyResponseModel supply;

  factory CustomSupplyResponseModel.fromJson(Map<String, dynamic> json) {
    final supplyJson = json['supply'];

    String value(String key, {String fallback = ''}) {
      return json[key]?.toString() ?? fallback;
    }

    double doubleValue(Object? value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    return CustomSupplyResponseModel(
      customSupplyId: value('id', fallback: value('_id')),
      name: value('name'),
      description: value('description'),
      unitPriceAmount: value('unitPriceAmount'),
      unitPriceCurrencyCode: value('unitPriceCurrencyCode'),
      minimumStock: doubleValue(json['minimumStock']),
      maximumStock: doubleValue(json['maximumStock']),
      unitMeasurement: value('unitMeasurement'),
      unitMeasurementAbbreviation: value('unitMeasurementAbbreviation'),
      pictureUrl: value('pictureUrl'),
      picturePublicId: value('picturePublicId'),
      accountId: value('accountId'),
      supply: supplyJson is Map<String, dynamic>
          ? SupplyResponseModel.fromJson(supplyJson)
          : const SupplyResponseModel(
              supplyId: '',
              name: '',
              description: '',
              category: '',
              isPerishable: false,
            ),
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
      supply: supply.toDomain(),
    );
  }
}
