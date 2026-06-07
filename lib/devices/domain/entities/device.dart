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
    this.customSupplyId,
    this.thresholdId,
    this.measurement,
  });

  final String deviceId;
  final String accountId;
  final String macAddress;
  final String description;
  final DeviceStatus status;
  final DeviceSpecifications? specifications;
  final String? branchId;
  final String? customSupplyId;
  final String? thresholdId;
  final DeviceMeasurement? measurement;

  String? get firmwareVersion => specifications?.firmwareVersion;

  bool get isOnboardingComplete =>
      status == DeviceStatus.configured || status == DeviceStatus.active;

  bool get hasBatch => customSupplyId != null;
}
