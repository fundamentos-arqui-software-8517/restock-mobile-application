import 'package:restock/devices/domain/entities/create_threshold_command.dart';

class CreateThresholdRequest {
  const CreateThresholdRequest({
    required this.accountId,
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
      'minStock': minStock,
      'maxStock': maxStock,
      'anomalyThreshold': anomalyThreshold,
      if (minTemperature != null) 'minTemperature': minTemperature,
      if (maxTemperature != null) 'maxTemperature': maxTemperature,
      if (minHumidity != null) 'minHumidity': minHumidity,
      if (maxHumidity != null) 'maxHumidity': maxHumidity,
    };
  }
}
