import 'dart:convert';
import 'dart:io';

import 'package:restock/devices/infrastructure/models/batch_response_model.dart';
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/shared/infrastructure/constants/api_constants.dart';

class BatchRemoteDataProvider {
  BatchRemoteDataProvider({required this.http});

  final AuthHttpClient http;

  Future<List<BatchResponseModel>> getBatchesByAccountId(
    String accountId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.batches}',
    ).replace(queryParameters: {'accountId': accountId});
    final response = await http.get(uri);
    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((j) => BatchResponseModel.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load batches: ${response.statusCode}');
  }
}
