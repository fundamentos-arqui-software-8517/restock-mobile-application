import 'package:restock/analytics/domain/entities/recent_sale.dart';

class RecentSaleModel {
  const RecentSaleModel({
    required this.saleId,
    required this.branchId,
    required this.totalAmount,
    required this.saleDate,
    required this.status,
  });

  final String saleId;
  final String branchId;
  final double totalAmount;
  final DateTime? saleDate;
  final String status;

  factory RecentSaleModel.fromJson(Map<String, dynamic> json) {
    return RecentSaleModel(
      saleId: json['saleId']?.toString() ?? '',
      branchId: json['branchId']?.toString() ?? '',
      totalAmount: _toDouble(json['totalAmount']),
      saleDate: DateTime.tryParse(json['saleDate']?.toString() ?? ''),
      status: json['status']?.toString() ?? '',
    );
  }

  RecentSale toDomain() {
    return RecentSale(
      saleId: saleId,
      branchId: branchId,
      totalAmount: totalAmount,
      saleDate: saleDate,
      status: status,
    );
  }
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
