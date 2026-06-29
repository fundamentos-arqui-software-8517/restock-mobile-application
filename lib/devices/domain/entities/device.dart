import 'device_measurement.dart';
import 'device_specifications.dart';
import 'device_status.dart';

class Device {
  const Device({
    required this.deviceId,
    required this.accountId,
    required this.macAddress,
    required this.description,
    required this.status,
    this.specifications,
    this.branchId,
    this.assignedBatchId,
    this.supplyThresholdId,
    this.measurement,
  });

  final String deviceId;
  final String accountId;
  final String macAddress;
  final String description;
  final DeviceStatus status;
  final DeviceSpecifications? specifications;
  final String? branchId;
  final String? assignedBatchId;
  final String? supplyThresholdId;
  final DeviceMeasurement? measurement;

  String? get firmwareVersion => specifications?.firmwareVersion;

  bool get isOnboardingComplete =>
      status == DeviceStatus.configured ||
      status == DeviceStatus.calibrated ||
      status == DeviceStatus.active;

  bool get hasBatch => assignedBatchId != null;
}
