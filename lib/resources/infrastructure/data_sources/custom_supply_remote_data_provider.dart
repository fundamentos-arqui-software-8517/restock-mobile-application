import 'package:restock/resources/infrastructure/models/custom_supply_model.dart';
import 'package:restock/shared/infrastructure/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

/// A data provider for fetching custom supply data from a remote API.
/// 
/// This class uses the `http` package to make GET requests to the API endpoint defined in `ApiConstants`.
/// 
/// The `getCustomSuppliesByBranchId` method retrieves a list of custom supplies based on the branch ID and returns a list of `CustomSupplyResponseModel` objects.
class CustomSupplyRemoteDataProvider {

  /// Fetches custom supplies for a specific branch ID from the remote API.
  /// 
  /// Returns a list of `CustomSupplyResponseModel` objects if the request is successful.
  /// 
  /// Throws an exception if the request fails or if the response status code is not OK.
  Future<List<CustomSupplyResponseModel>> getCustomSuppliesByBranchId() async {
    try {
      final Uri uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.customSupplyByBranchId}",
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
