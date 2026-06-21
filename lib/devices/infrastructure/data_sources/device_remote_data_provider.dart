import 'dart:convert';
import 'dart:io';

import 'package:restock/devices/infrastructure/models/assign_batch_request.dart';
import 'package:restock/devices/infrastructure/models/assign_branch_request.dart';
import 'package:restock/devices/infrastructure/models/assign_threshold_request.dart';
import 'package:restock/devices/infrastructure/models/device_response_model.dart';
import 'package:restock/devices/infrastructure/models/register_device_request.dart';
import 'package:restock/devices/infrastructure/models/update_measurement_request.dart';
import 'package:restock/devices/infrastructure/models/update_specifications_request.dart';
import 'package:restock/devices/infrastructure/models/update_status_request.dart';
import 'package:restock/devices/infrastructure/repositories/constants/devices_api_constants.dart';
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/shared/infrastructure/repositories/constants/api_constants.dart';

class DeviceRemoteDataProvider {
  DeviceRemoteDataProvider({required this.http});

  final AuthHttpClient http;

  Future<List<DeviceResponseModel>> getDevicesByAccountId(
    String accountId,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${DevicesApiConstants.devices}',
      ).replace(queryParameters: {'accountId': accountId});
      final response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((j) => DeviceResponseModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to load devices: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<DeviceResponseModel> getDeviceById(String deviceId) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${DevicesApiConstants.deviceById.replaceAll('{deviceId}', deviceId)}',
      );
      final response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        return DeviceResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      throw Exception('Failed to get device: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<DeviceResponseModel> registerDevice(
    RegisterDeviceRequest request,
    String accountId,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${DevicesApiConstants.devices}',
      ).replace(queryParameters: {'accountId': accountId});
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == HttpStatus.created ||
          response.statusCode == HttpStatus.ok) {
        return DeviceResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      throw Exception('Failed to register device: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<DeviceResponseModel> updateSpecifications(
    String deviceId,
    UpdateSpecificationsRequest request,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${DevicesApiConstants.deviceSpecifications.replaceAll('{deviceId}', deviceId)}',
      );
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == HttpStatus.ok) {
        return DeviceResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      throw Exception(
        'Failed to update specifications: ${response.statusCode}',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<DeviceResponseModel> assignBranch(
    String deviceId,
    AssignBranchRequest request,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${DevicesApiConstants.deviceConfigBranch.replaceAll('{deviceId}', deviceId)}',
      );
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == HttpStatus.ok) {
        return DeviceResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      throw Exception('Failed to assign branch: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<DeviceResponseModel> assignBatch(
    String deviceId,
    AssignBatchRequest request,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${DevicesApiConstants.deviceConfigBatch.replaceAll('{deviceId}', deviceId)}',
      );
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == HttpStatus.ok) {
        return DeviceResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      throw Exception('Failed to assign batch: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<DeviceResponseModel> assignThreshold(
    String deviceId,
    AssignThresholdRequest request,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${DevicesApiConstants.deviceConfigThreshold.replaceAll('{deviceId}', deviceId)}',
      );
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.noContent) {
        if (response.body.isEmpty) {
          return getDeviceById(deviceId);
        }
        return DeviceResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      throw Exception('Failed to assign threshold: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<DeviceResponseModel> updateMeasurement(
    String deviceId,
    UpdateMeasurementRequest request,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${DevicesApiConstants.deviceConfigMeasurement.replaceAll('{deviceId}', deviceId)}',
      );
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == HttpStatus.ok) {
        return DeviceResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      throw Exception('Failed to update measurement: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStatus(
    String deviceId,
    UpdateStatusRequest request,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${DevicesApiConstants.deviceStatus.replaceAll('{deviceId}', deviceId)}',
      );
      final response = await http.patch(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode != HttpStatus.ok &&
          response.statusCode != HttpStatus.noContent) {
        throw Exception(
          'Failed to update device status: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
