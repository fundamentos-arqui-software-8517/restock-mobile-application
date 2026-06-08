import 'package:restock/devices/domain/entities/device_measurement.dart';

abstract class DeviceDetailEvent {
  const DeviceDetailEvent();
}

class DeviceDetailFetched extends DeviceDetailEvent {
  const DeviceDetailFetched(this.deviceId);

  final String deviceId;
}

class BatchAssigned extends DeviceDetailEvent {
  const BatchAssigned({
    required this.batchId,
    required this.customSupplyId,
    required this.minStock,
    required this.maxStock,
    required this.measurement,
  });

  final String batchId;
  final String customSupplyId;
  final double minStock;
  final double maxStock;
  final DeviceMeasurement measurement;
}

class DeviceUnlinked extends DeviceDetailEvent {
  const DeviceUnlinked();
}

class ThresholdsSaved extends DeviceDetailEvent {
  const ThresholdsSaved({
    required this.minStock,
    required this.maxStock,
    required this.anomalyThreshold,
    this.minTemperature,
    this.maxTemperature,
    this.minHumidity,
    this.maxHumidity,
  });

  final double minStock;
  final double maxStock;
  final double anomalyThreshold;
  final double? minTemperature;
  final double? maxTemperature;
  final double? minHumidity;
  final double? maxHumidity;
}
