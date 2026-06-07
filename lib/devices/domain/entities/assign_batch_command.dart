import 'device_measurement.dart';

class AssignBatchCommand {
  const AssignBatchCommand({
    required this.deviceId,
    required this.customSupplyId,
    required this.measurement,
  });

  final String deviceId;
  final String customSupplyId;
  final DeviceMeasurement measurement;
}
