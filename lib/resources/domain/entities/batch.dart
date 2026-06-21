class Batch {
  const Batch({
    required this.id,
    required this.code,
    required this.currentStock,
    required this.unitMeasurement,
    required this.unitMeasurementAbbreviation,
    required this.customSupplyId,
    required this.branchId,
    required this.accountId,
    this.customSupplyName,
    this.minimumStock,
    this.maximumStock,
    this.pictureUrl,
    this.expirationDate,
    this.entryDate,
  });

  final String id;
  final String code;
  final double currentStock;
  final String unitMeasurement;
  final String unitMeasurementAbbreviation;
  final String customSupplyId;
  final String branchId;
  final String accountId;
  final String? customSupplyName;
  final double? minimumStock;
  final double? maximumStock;
  final String? pictureUrl;
  final DateTime? expirationDate;
  final DateTime? entryDate;

  String get displayLabel {
    final stock = unitMeasurementAbbreviation.isNotEmpty
        ? '${currentStock.toStringAsFixed(1)} $unitMeasurementAbbreviation'
        : currentStock.toStringAsFixed(1);
    return '$code  ($stock)';
  }
}
