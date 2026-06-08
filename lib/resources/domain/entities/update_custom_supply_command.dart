import 'package:image_picker/image_picker.dart';

/// Command used to update a custom supply.
class UpdateCustomSupplyCommand {
  const UpdateCustomSupplyCommand({
    required this.customSupplyId,
    required this.supplyId,
    required this.name,
    required this.description,
    required this.unitPriceAmount,
    required this.unitPriceCurrencyCode,
    required this.minimumStock,
    required this.maximumStock,
    required this.unitMeasurement,
    required this.unitMeasurementAbbreviation,
    this.picture,
  });

  final String customSupplyId;
  final String supplyId;
  final String name;
  final String description;
  final String unitPriceAmount;
  final String unitPriceCurrencyCode;
  final double minimumStock;
  final double maximumStock;
  final String unitMeasurement;
  final String unitMeasurementAbbreviation;
  final XFile? picture;
}
