import 'device_measurement.dart';

class UpdateMeasurementCommand {
  const UpdateMeasurementCommand({
    required this.deviceId,
    required this.measurement,
  });

  final String deviceId;
  final DeviceMeasurement measurement;
}
