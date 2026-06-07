import 'package:restock/devices/domain/entities/device_threshold.dart';

class DeviceThresholdResponseModel {
  const DeviceThresholdResponseModel({
    required this.thresholdId,
    required this.accountId,
    required this.minStock,
    required this.maxStock,
    required this.anomalyThreshold,
    this.minTemperature,
    this.maxTemperature,
    this.minHumidity,
    this.maxHumidity,
  });

  final String thresholdId;
  final String accountId;
  final double minStock;
  final double maxStock;
  final double anomalyThreshold;
  final double? minTemperature;
  final double? maxTemperature;
  final double? minHumidity;
  final double? maxHumidity;

  factory DeviceThresholdResponseModel.fromJson(Map<String, dynamic> json) {
    String value(String key, {String fallback = ''}) =>
        json[key]?.toString() ?? fallback;
    double? optDouble(String key) =>
        json[key] != null ? (json[key] as num).toDouble() : null;

    return DeviceThresholdResponseModel(
      thresholdId: value('id', fallback: value('thresholdId')),
      accountId: value('accountId'),
      minStock: (json['minStock'] as num?)?.toDouble() ?? 0.0,
      maxStock: (json['maxStock'] as num?)?.toDouble() ?? 0.0,
      anomalyThreshold: (json['anomalyThreshold'] as num?)?.toDouble() ?? 0.0,
      minTemperature: optDouble('minTemperature'),
      maxTemperature: optDouble('maxTemperature'),
      minHumidity: optDouble('minHumidity'),
      maxHumidity: optDouble('maxHumidity'),
    );
  }

  DeviceThreshold toDomain() {
    return DeviceThreshold(
      thresholdId: thresholdId,
      accountId: accountId,
      minStock: minStock,
      maxStock: maxStock,
      anomalyThreshold: anomalyThreshold,
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
      minHumidity: minHumidity,
      maxHumidity: maxHumidity,
    );
  }
}
