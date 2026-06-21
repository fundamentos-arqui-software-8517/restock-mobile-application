import 'package:restock/analytics/domain/entities/stock_discrepancy.dart';

class StockDiscrepancyModel {
  const StockDiscrepancyModel({
    required this.discrepancyId,
    required this.physicalStock,
    required this.systemStock,
    required this.difference,
    required this.riskLevel,
    required this.status,
    required this.isConciliated,
  });

  final String discrepancyId;
  final double physicalStock;
  final double systemStock;
  final double difference;
  final String riskLevel;
  final String status;
  final bool isConciliated;

  factory StockDiscrepancyModel.fromJson(Map<String, dynamic> json) {
    return StockDiscrepancyModel(
      discrepancyId: json['discrepancyId']?.toString() ?? '',
      physicalStock: _toDouble(json['physicalStock']),
      systemStock: _toDouble(json['systemStock']),
      difference: _toDouble(json['difference']),
      riskLevel: json['riskLevel']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      isConciliated: json['isConciliated'] == true,
    );
  }

  StockDiscrepancy toDomain({
    required String productId,
    required String productName,
  }) {
    return StockDiscrepancy(
      discrepancyId: discrepancyId,
      physicalStock: physicalStock,
      systemStock: systemStock,
      difference: difference,
      riskLevel: riskLevel,
      status: status,
      isConciliated: isConciliated,
      productId: productId,
      productName: productName,
    );
  }
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
