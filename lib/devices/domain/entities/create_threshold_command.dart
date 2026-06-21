class CreateThresholdCommand {
  const CreateThresholdCommand({
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
}
