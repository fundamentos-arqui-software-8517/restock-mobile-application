import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/// Request model for registering a custom supply.
class RegisterCustomSupplyRequest {
  const RegisterCustomSupplyRequest({
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

  Future<http.MultipartRequest> toMultipartRequest(Uri uri) async {
    final request = http.MultipartRequest('POST', uri);

    request.fields['accountId'] = accountId;
    request.fields['supplyId'] = supplyId;
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['unitPrice'] = '$unitPriceAmount $unitPriceCurrencyCode';
    request.fields['minimumStock'] = minimumStock.toString();
    request.fields['maximumStock'] = maximumStock.toString();
    request.fields['unitMeasurement'] = unitMeasurement;
    request.fields['unitMeasurementAbbreviation'] = unitMeasurementAbbreviation;

    if (picture != null) {
      final bytes = await picture!.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('picture', bytes, filename: picture!.name),
      );
    }

    return request;
  }
}
