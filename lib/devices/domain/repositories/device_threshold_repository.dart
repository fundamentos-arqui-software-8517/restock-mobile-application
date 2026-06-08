import 'package:restock/devices/domain/entities/create_threshold_command.dart';
import 'package:restock/devices/domain/entities/device_threshold.dart';

abstract class DeviceThresholdRepository {
  Future<List<DeviceThreshold>> getThresholdsByAccountId(String accountId);
  Future<DeviceThreshold> getThresholdById(String thresholdId);
  Future<DeviceThreshold> createThreshold(CreateThresholdCommand command);
}
