import 'package:image_picker/image_picker.dart';

/// Command used to register a custom supply.
class RegisterCustomSupplyCommand {
  const RegisterCustomSupplyCommand({
    required this.accountId,
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

  final String accountId;
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
