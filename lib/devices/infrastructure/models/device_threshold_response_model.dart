import 'package:restock/devices/domain/entities/device_threshold.dart';

class DeviceThresholdResponseModel {
  const DeviceThresholdResponseModel({
    required this.thresholdId,
    required this.accountId,
    required this.minStock,
    required this.maxStock,
    required this.anomalyThreshold,
    this.customSupplyId,
    this.minTemperature,
    this.maxTemperature,
    this.minHumidity,
    this.maxHumidity,
  });

  final String thresholdId;
  final String accountId;
  final String? customSupplyId;
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
    double? optDouble(String key) => _toDouble(json[key]);
    final temperature = _asMap(json['temperature']);
    final humidity = _asMap(json['humidity']);

    return DeviceThresholdResponseModel(
      thresholdId: value('id', fallback: value('thresholdId')),
      accountId: value('accountId'),
      customSupplyId: json['customSupplyId']?.toString(),
      minStock: (json['minStock'] as num?)?.toDouble() ?? 0.0,
      maxStock: (json['maxStock'] as num?)?.toDouble() ?? 0.0,
      anomalyThreshold: (json['anomalyThreshold'] as num?)?.toDouble() ?? 0.0,
      minTemperature:
          _toDouble(temperature?['minCelsius']) ?? optDouble('minTemperature'),
      maxTemperature:
          _toDouble(temperature?['maxCelsius']) ?? optDouble('maxTemperature'),
      minHumidity:
          _toDouble(humidity?['minPercentage']) ?? optDouble('minHumidity'),
      maxHumidity:
          _toDouble(humidity?['maxPercentage']) ?? optDouble('maxHumidity'),
    );
  }

  static Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    return null;
  }

  DeviceThreshold toDomain() {
    return DeviceThreshold(
      thresholdId: thresholdId,
      accountId: accountId,
      customSupplyId: customSupplyId,
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
