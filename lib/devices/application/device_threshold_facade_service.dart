import 'package:restock/devices/domain/entities/assign_threshold_command.dart';
import 'package:restock/devices/domain/entities/create_threshold_command.dart';
import 'package:restock/devices/domain/entities/device_threshold.dart';
import 'package:restock/devices/domain/repositories/device_repository.dart';
import 'package:restock/devices/domain/repositories/device_threshold_repository.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

class DeviceThresholdFacadeService {
  const DeviceThresholdFacadeService({
    required this.thresholdRepository,
    required this.deviceRepository,
    required this.tokenStorage,
  });

  final DeviceThresholdRepository thresholdRepository;
  final DeviceRepository deviceRepository;
  final TokenStorage tokenStorage;

  Future<DeviceThreshold> createAndAssign({
    required String deviceId,
    required String customSupplyId,
    required double minStock,
    required double maxStock,
    required double anomalyThreshold,
    double? minTemperature,
    double? maxTemperature,
    double? minHumidity,
    double? maxHumidity,
  }) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('Account ID not found');

      // 1. Create threshold
      final threshold = await thresholdRepository.createThreshold(
        CreateThresholdCommand(
          accountId: accountId,
          deviceId: deviceId,
          customSupplyId: customSupplyId,
          minStock: minStock,
          maxStock: maxStock,
          anomalyThreshold: anomalyThreshold,
          minTemperature: minTemperature,
          maxTemperature: maxTemperature,
          minHumidity: minHumidity,
          maxHumidity: maxHumidity,
        ),
      );

      // 2. Assign threshold to device
      await deviceRepository.assignThreshold(
        AssignThresholdCommand(
          deviceId: deviceId,
          thresholdId: threshold.thresholdId,
        ),
      );

      return threshold;
    } catch (e) {
      throw Exception('Failed to create and assign threshold: $e');
    }
  }

  Future<DeviceThreshold> getThresholdById(String thresholdId) async {
    try {
      return await thresholdRepository.getThresholdById(thresholdId);
    } catch (e) {
      throw Exception('Failed to get threshold: $e');
    }
  }
}
