import 'package:restock/arm/infrastructure/models/custom_supply_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomSupplyRemoteDataProvider {



  Future<List<CustomSupplyResponseModel>> getCustomSuppliesByBranchId() async {
    try {
      final Uri uri = Uri.parse('');

     
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => CustomSupplyResponseModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load custom supplies: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
