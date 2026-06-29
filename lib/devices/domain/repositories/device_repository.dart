import 'package:restock/devices/domain/entities/assign_batch_command.dart';
import 'package:restock/devices/domain/entities/assign_branch_command.dart';
import 'package:restock/devices/domain/entities/assign_threshold_command.dart';
import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/register_device_command.dart';
import 'package:restock/devices/domain/entities/update_device_specifications_command.dart';
import 'package:restock/devices/domain/entities/update_device_status_command.dart';
import 'package:restock/devices/domain/entities/update_measurement_command.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevicesByAccountId(String accountId);
  Future<Device> getDeviceById(String deviceId);
  Future<Device> registerDevice(RegisterDeviceCommand command);
  Future<Device> updateSpecifications(
    UpdateDeviceSpecificationsCommand command,
  );
  Future<Device> assignBranch(AssignBranchCommand command);
  Future<Device> assignBatch(AssignBatchCommand command);
  Future<Device> assignThreshold(AssignThresholdCommand command);
  Future<Device> updateMeasurement(UpdateMeasurementCommand command);
  Future<void> updateStatus(UpdateDeviceStatusCommand command);
}
