class DeviceThreshold {
  const DeviceThreshold({
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
}
