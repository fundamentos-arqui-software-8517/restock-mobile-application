import 'dart:convert';
import 'dart:io';

import 'package:restock/devices/infrastructure/models/create_threshold_request.dart';
import 'package:restock/devices/infrastructure/models/device_threshold_response_model.dart';
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/shared/infrastructure/constants/api_constants.dart';

class DeviceThresholdRemoteDataProvider {
  DeviceThresholdRemoteDataProvider({required this.http});

  final AuthHttpClient http;

  Future<List<DeviceThresholdResponseModel>> getThresholdsByAccountId(
    String accountId,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.deviceThresholds}',
      ).replace(queryParameters: {'accountId': accountId});
      final response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (j) => DeviceThresholdResponseModel.fromJson(
                j as Map<String, dynamic>,
              ),
            )
            .toList();
      }
      throw Exception('Failed to load thresholds: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<DeviceThresholdResponseModel> getThresholdById(
    String thresholdId,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.deviceThresholdById.replaceAll('{thresholdId}', thresholdId)}',
      );
      final response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        return DeviceThresholdResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      throw Exception('Failed to get threshold: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<DeviceThresholdResponseModel> createThreshold(
    CreateThresholdRequest request,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.deviceThresholds}',
      );
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == HttpStatus.created ||
          response.statusCode == HttpStatus.ok) {
        return DeviceThresholdResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      throw Exception('Failed to create threshold: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }
}
