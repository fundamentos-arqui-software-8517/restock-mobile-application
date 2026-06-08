class Batch {
  const Batch({
    required this.id,
    required this.code,
    required this.currentStock,
    required this.customSupplyId,
    required this.branchId,
    this.customSupplyName,
    this.unitMeasurementAbbreviation,
    this.minimumStock,
    this.maximumStock,
    this.expirationDate,
    this.entryDate,
  });

  final String id;
  final String code;
  final double currentStock;
  final String customSupplyId;
  final String branchId;
  final String? customSupplyName;
  final String? unitMeasurementAbbreviation;
  final double? minimumStock;
  final double? maximumStock;
  final DateTime? expirationDate;
  final DateTime? entryDate;

  String get displayLabel {
    final stock = unitMeasurementAbbreviation != null
        ? '${currentStock.toStringAsFixed(1)} $unitMeasurementAbbreviation'
        : currentStock.toStringAsFixed(1);
    return '$code  ($stock)';
  }
}
