import 'package:restock/devices/domain/entities/assign_batch_command.dart';
import 'package:restock/devices/domain/entities/assign_branch_command.dart';
import 'package:restock/devices/domain/entities/assign_threshold_command.dart';
import 'package:restock/devices/domain/entities/batch.dart';
import 'package:restock/devices/domain/entities/create_threshold_command.dart';
import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/device_measurement.dart';
import 'package:restock/devices/domain/entities/device_specifications.dart';
import 'package:restock/devices/domain/entities/device_status.dart';
import 'package:restock/devices/domain/entities/register_device_command.dart';
import 'package:restock/devices/domain/entities/update_device_specifications_command.dart';
import 'package:restock/devices/domain/entities/update_device_status_command.dart';
import 'package:restock/devices/domain/entities/update_measurement_command.dart';
import 'package:restock/devices/domain/repositories/batch_repository.dart';
import 'package:restock/devices/domain/repositories/device_repository.dart';
import 'package:restock/devices/domain/repositories/device_threshold_repository.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

class DeviceFacadeService {
  const DeviceFacadeService({
    required this.deviceRepository,
    required this.batchRepository,
    required this.thresholdRepository,
    required this.branchFacadeService,
    required this.tokenStorage,
  });

  final DeviceRepository deviceRepository;
  final BatchRepository batchRepository;
  final DeviceThresholdRepository thresholdRepository;
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

  Future<List<Batch>> getBatchesForAssignment() async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('Account ID not found');
      return await batchRepository.getBatchesByAccountId(accountId);
    } catch (e) {
      throw Exception('Failed to fetch batches: $e');
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
    required String batchId,
    required String customSupplyId,
    required double minStock,
    required double maxStock,
    required DeviceMeasurement measurement,
  }) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('Account ID not found');

      // 1. Assign batch
      await deviceRepository.assignBatch(
        AssignBatchCommand(deviceId: deviceId, batchId: batchId),
      );

      // 2. Update measurement — compute grossWeight and set calibrationDate
      final grossWeight = measurement.netWeight + measurement.tareWeight;
      final calibrationDate =
          DateTime.now().toIso8601String().substring(0, 10);
      await deviceRepository.updateMeasurement(
        UpdateMeasurementCommand(
          deviceId: deviceId,
          measurement: DeviceMeasurement(
            netWeight: measurement.netWeight,
            tareWeight: measurement.tareWeight,
            grossWeight: grossWeight,
            weightUnitName: measurement.weightUnitName,
            weightUnitAbbreviation: measurement.weightUnitAbbreviation,
            calibrationDate: calibrationDate,
          ),
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

      // 5. Create default threshold silently and assign it
      final threshold = await thresholdRepository.createThreshold(
        CreateThresholdCommand(
          accountId: accountId,
          customSupplyId: customSupplyId,
          minStock: minStock,
          maxStock: maxStock,
          anomalyThreshold: 1.0,
        ),
      );
      await deviceRepository.assignThreshold(
        AssignThresholdCommand(
          deviceId: deviceId,
          thresholdId: threshold.thresholdId,
        ),
      );

      // 6. Set status to CONFIGURED
      await deviceRepository.updateStatus(
        UpdateDeviceStatusCommand(
          deviceId: deviceId,
          status: DeviceStatus.configured,
        ),
      );

      // 7. Return updated device
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
