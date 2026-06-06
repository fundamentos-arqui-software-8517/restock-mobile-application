import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as pkg_http;
import 'package:restock/resources/infrastructure/models/supply_response_model.dart';

import '../../../shared/infrastructure/constants/api_constants.dart';

/// A data provider for fetching supply data from a remote API.
class SupplyRemoteDataProvider {
  SupplyRemoteDataProvider({required this.http});

  final pkg_http.Client http;

  /// Fetches a list of supplies from the remote API.
  Future<List<SupplyResponseModel>> getSupplies() async {
    try {
      final Uri uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.supplies}",
      );
      final response = await http.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SupplyResponseModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load supplies: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
