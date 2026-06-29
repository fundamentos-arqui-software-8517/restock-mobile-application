import 'package:restock/analytics/domain/entities/critical_product.dart';

class CriticalProductModel {
  const CriticalProductModel({
    required this.productId,
    required this.productName,
    required this.supplyId,
    required this.totalStock,
    required this.minStock,
    required this.maxStock,
    required this.stockDeficit,
    required this.branchName,
    required this.branchId,
    required this.unitMeasurement,
  });

  final String productId;
  final String productName;
  final String supplyId;
  final double totalStock;
  final double minStock;
  final double maxStock;
  final double stockDeficit;
  final String branchName;
  final String branchId;
  final String unitMeasurement;

  factory CriticalProductModel.fromJson(Map<String, dynamic> json) {
    return CriticalProductModel(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      supplyId: json['supplyId']?.toString() ?? '',
      totalStock: _toDouble(json['totalStock']),
      minStock: _toDouble(json['minStock']),
      maxStock: _toDouble(json['maxStock']),
      stockDeficit: _toDouble(json['stockDeficit']),
      branchName: json['branchName']?.toString() ?? '',
      branchId: json['branchId']?.toString() ?? '',
      unitMeasurement: json['unitMeasurement']?.toString() ?? '',
    );
  }

  CriticalProduct toDomain() {
    return CriticalProduct(
      productId: productId,
      productName: productName,
      supplyId: supplyId,
      totalStock: totalStock,
      minStock: minStock,
      maxStock: maxStock,
      stockDeficit: stockDeficit,
      branchName: branchName,
      branchId: branchId,
      unitMeasurement: unitMeasurement,
    );
  }
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
