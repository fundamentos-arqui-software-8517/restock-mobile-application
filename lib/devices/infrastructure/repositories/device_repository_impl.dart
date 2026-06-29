import 'package:restock/devices/domain/entities/assign_batch_command.dart';
import 'package:restock/devices/domain/entities/assign_branch_command.dart';
import 'package:restock/devices/domain/entities/assign_threshold_command.dart';
import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/register_device_command.dart';
import 'package:restock/devices/domain/entities/update_device_specifications_command.dart';
import 'package:restock/devices/domain/entities/update_device_status_command.dart';
import 'package:restock/devices/domain/entities/update_measurement_command.dart';
import 'package:restock/devices/domain/repositories/device_repository.dart';
import 'package:restock/devices/infrastructure/data_sources/device_remote_data_provider.dart';
import 'package:restock/devices/infrastructure/models/assign_batch_request.dart';
import 'package:restock/devices/infrastructure/models/assign_branch_request.dart';
import 'package:restock/devices/infrastructure/models/assign_threshold_request.dart';
import 'package:restock/devices/infrastructure/models/register_device_request.dart';
import 'package:restock/devices/infrastructure/models/update_measurement_request.dart';
import 'package:restock/devices/infrastructure/models/update_specifications_request.dart';
import 'package:restock/devices/infrastructure/models/update_status_request.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  const DeviceRepositoryImpl({required this.deviceRemoteDataProvider});

  final DeviceRemoteDataProvider deviceRemoteDataProvider;

  @override
  Future<List<Device>> getDevicesByAccountId(String accountId) async {
    try {
      final response = await deviceRemoteDataProvider.getDevicesByAccountId(
        accountId,
      );
      return response.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get devices: $e');
    }
  }

  @override
  Future<Device> getDeviceById(String deviceId) async {
    try {
      final response = await deviceRemoteDataProvider.getDeviceById(deviceId);
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to get device: $e');
    }
  }

  @override
  Future<Device> registerDevice(RegisterDeviceCommand command) async {
    try {
      final request = RegisterDeviceRequest(
        accountId: command.accountId,
        macAddress: command.macAddress,
        description: command.description,
      );
      final response = await deviceRemoteDataProvider.registerDevice(
        request,
        command.accountId,
      );
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to register device: $e');
    }
  }

  @override
  Future<Device> updateSpecifications(
    UpdateDeviceSpecificationsCommand command,
  ) async {
    try {
      final request = UpdateSpecificationsRequest(
        manufacturer: command.specifications.manufacturer,
        model: command.specifications.model,
        firmwareVersion: command.specifications.firmwareVersion,
      );
      final response = await deviceRemoteDataProvider.updateSpecifications(
        command.deviceId,
        request,
      );
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to update specifications: $e');
    }
  }

  @override
  Future<Device> assignBranch(AssignBranchCommand command) async {
    try {
      final request = AssignBranchRequest(branchId: command.branchId);
      final response = await deviceRemoteDataProvider.assignBranch(
        command.deviceId,
        request,
      );
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to assign branch: $e');
    }
  }

  @override
  Future<Device> assignBatch(AssignBatchCommand command) async {
    try {
      final request = AssignBatchRequest(batchId: command.batchId);
      final response = await deviceRemoteDataProvider.assignBatch(
        command.deviceId,
        request,
      );
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to assign batch: $e');
    }
  }

  @override
  Future<Device> assignThreshold(AssignThresholdCommand command) async {
    try {
      final request = AssignThresholdRequest.fromCommand(command);
      final response = await deviceRemoteDataProvider.assignThreshold(
        command.deviceId,
        request,
      );
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to assign threshold: $e');
    }
  }

  @override
  Future<Device> updateMeasurement(UpdateMeasurementCommand command) async {
    try {
      final m = command.measurement;
      final gross = m.grossWeight ?? (m.netWeight + m.tareWeight);
      final date =
          m.calibrationDate ??
          DateTime.now().toIso8601String().substring(0, 10);
      final request = UpdateMeasurementRequest(
        netWeight: m.netWeight,
        tareWeight: m.tareWeight,
        grossWeight: gross,
        calibrationDate: date,
        weightUnitName: m.weightUnitName,
        weightUnitAbbreviation: m.weightUnitAbbreviation,
      );
      final response = await deviceRemoteDataProvider.updateMeasurement(
        command.deviceId,
        request,
      );
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to update measurement: $e');
    }
  }

  @override
  Future<void> updateStatus(UpdateDeviceStatusCommand command) async {
    try {
      final request = UpdateStatusRequest(status: command.status.toApiString());
      await deviceRemoteDataProvider.updateStatus(command.deviceId, request);
    } catch (e) {
      throw Exception('Failed to update device status: $e');
    }
  }
}
