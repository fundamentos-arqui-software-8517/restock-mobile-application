import 'package:restock/devices/domain/entities/create_threshold_command.dart';

class CreateThresholdRequest {
  const CreateThresholdRequest({
    required this.accountId,
    required this.deviceId,
    required this.customSupplyId,
    required this.minStock,
    required this.maxStock,
    required this.anomalyThreshold,
    this.minTemperature,
    this.maxTemperature,
    this.minHumidity,
    this.maxHumidity,
  });

  factory CreateThresholdRequest.fromCommand(CreateThresholdCommand cmd) {
    return CreateThresholdRequest(
      accountId: cmd.accountId,
      deviceId: cmd.deviceId,
      customSupplyId: cmd.customSupplyId,
      minStock: cmd.minStock,
      maxStock: cmd.maxStock,
      anomalyThreshold: cmd.anomalyThreshold,
      minTemperature: cmd.minTemperature,
      maxTemperature: cmd.maxTemperature,
      minHumidity: cmd.minHumidity,
      maxHumidity: cmd.maxHumidity,
    );
  }

  final String accountId;
  final String deviceId;
  final String customSupplyId;
  final double minStock;
  final double maxStock;
  final double anomalyThreshold;
  final double? minTemperature;
  final double? maxTemperature;
  final double? minHumidity;
  final double? maxHumidity;

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'deviceId': deviceId,
      'customSupplyId': customSupplyId,
      'minStock': minStock,
      'maxStock': maxStock,
      'anomalyThreshold': anomalyThreshold,
      if (minTemperature != null) 'minTemperatureCelsius': minTemperature,
      if (maxTemperature != null) 'maxTemperatureCelsius': maxTemperature,
      if (minHumidity != null) 'minHumidityPercentage': minHumidity,
      if (maxHumidity != null) 'maxHumidityPercentage': maxHumidity,
    };
  }
}
