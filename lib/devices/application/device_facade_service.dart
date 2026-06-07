import 'package:restock/devices/domain/entities/assign_batch_command.dart';
import 'package:restock/devices/domain/entities/assign_branch_command.dart';
import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/device_measurement.dart';
import 'package:restock/devices/domain/entities/device_specifications.dart';
import 'package:restock/devices/domain/entities/device_status.dart';
import 'package:restock/devices/domain/entities/register_device_command.dart';
import 'package:restock/devices/domain/entities/update_device_specifications_command.dart';
import 'package:restock/devices/domain/entities/update_device_status_command.dart';
import 'package:restock/devices/domain/entities/update_measurement_command.dart';
import 'package:restock/devices/domain/repositories/device_repository.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

class DeviceFacadeService {
  const DeviceFacadeService({
    required this.deviceRepository,
    required this.branchFacadeService,
    required this.tokenStorage,
  });

  final DeviceRepository deviceRepository;
  final BranchFacadeService branchFacadeService;
  final TokenStorage tokenStorage;

  Future<List<Device>> getDevicesByAccountId() async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('Account ID not found');
      return await deviceRepository.getDevicesByAccountId(accountId);
    } catch (e) {
      throw Exception('Failed to fetch devices: $e');
    }
  }

  Future<Device> getDeviceById(String deviceId) async {
    try {
      return await deviceRepository.getDeviceById(deviceId);
    } catch (e) {
      throw Exception('Failed to fetch device: $e');
    }
  }

  Future<Device> registerDevice({
    required String macAddress,
    required String description,
  }) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('Account ID not found');
      final command = RegisterDeviceCommand(
        accountId: accountId,
        macAddress: macAddress,
        description: description,
      );
      return await deviceRepository.registerDevice(command);
    } catch (e) {
      throw Exception('Failed to register device: $e');
    }
  }

  Future<void> unlinkDevice(String deviceId) async {
    try {
      await deviceRepository.updateStatus(
        UpdateDeviceStatusCommand(
          deviceId: deviceId,
          status: DeviceStatus.inactive,
        ),
      );
    } catch (e) {
      throw Exception('Failed to unlink device: $e');
    }
  }

  Future<Device> completeOnboarding({
    required String deviceId,
    required String customSupplyId,
    required DeviceMeasurement measurement,
  }) async {
    try {
      // 1. Assign batch (supply)
      await deviceRepository.assignBatch(
        AssignBatchCommand(
          deviceId: deviceId,
          customSupplyId: customSupplyId,
          measurement: measurement,
        ),
      );

      // 2. Update measurement with calibration date
      await deviceRepository.updateMeasurement(
        UpdateMeasurementCommand(
          deviceId: deviceId,
          measurement: measurement.copyWith(calibrationDate: DateTime.now()),
        ),
      );

      // 3. Add default specifications silently
      await deviceRepository.updateSpecifications(
        UpdateDeviceSpecificationsCommand(
          deviceId: deviceId,
          specifications: DeviceSpecifications.defaults,
        ),
      );

      // 4. Assign branch — resolve default branchId
      final branchId = await _resolveDefaultBranchId();
      await deviceRepository.assignBranch(
        AssignBranchCommand(deviceId: deviceId, branchId: branchId),
      );

      // 5. Set status to CONFIGURED
      await deviceRepository.updateStatus(
        UpdateDeviceStatusCommand(
          deviceId: deviceId,
          status: DeviceStatus.configured,
        ),
      );

      // 6. Return updated device
      return await deviceRepository.getDeviceById(deviceId);
    } catch (e) {
      throw Exception('Failed to complete onboarding: $e');
    }
  }

  Future<String> _resolveDefaultBranchId() async {
    final cached = await tokenStorage.readBranchId();
    if (cached != null && cached.isNotEmpty) return cached;

    final branches = await branchFacadeService.getBranchesByAccountId();
    if (branches.isEmpty) {
      throw Exception(
        'No hay branches creadas. Crea una branch antes de configurar devices.',
      );
    }
    return branches.first.branchId;
  }
}
