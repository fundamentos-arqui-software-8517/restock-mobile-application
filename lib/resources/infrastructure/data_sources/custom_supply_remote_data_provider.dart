import 'package:restock/resources/infrastructure/models/custom_supply_model.dart';
import 'package:restock/shared/infrastructure/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CustomSupplyRemoteDataProvider {
  Future<List<CustomSupplyResponseModel>> getCustomSuppliesByBranchId() async {
    try {
      final Uri uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.customSupplyByAccountId}",
      );

      final response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => CustomSupplyResponseModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load custom supplies: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
