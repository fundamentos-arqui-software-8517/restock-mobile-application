import 'package:restock/devices/domain/entities/batch.dart';

class BatchResponseModel {
  const BatchResponseModel({
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

  factory BatchResponseModel.fromJson(Map<String, dynamic> json) {
    String value(String key, {String fallback = ''}) =>
        json[key]?.toString() ?? fallback;

    // customSupplyId may come flat or nested inside a 'customSupply' object
    String resolveCustomSupplyId() {
      final flat = json['customSupplyId']?.toString();
      if (flat != null && flat.isNotEmpty) return flat;
      final nested = json['customSupply'];
      if (nested is Map<String, dynamic>) {
        return nested['id']?.toString() ?? '';
      }
      return '';
    }

    String? resolveCustomSupplyName() {
      final nested = json['customSupply'];
      if (nested is Map<String, dynamic>) {
        return nested['name']?.toString();
      }
      return null;
    }

    String? resolveUnitAbbreviation() {
      // may come flat or nested inside unitMeasurement / customSupply.unitMeasurement
      final flat = json['unitMeasurementAbbreviation']?.toString();
      if (flat != null && flat.isNotEmpty) return flat;
      final nested = json['customSupply'];
      if (nested is Map<String, dynamic>) {
        final um = nested['unitMeasurement'];
        if (um is Map<String, dynamic>) {
          return um['abbreviation']?.toString();
        }
      }
      return null;
    }

    double? resolveMinimumStock() {
      final nested = json['customSupply'];
      if (nested is Map<String, dynamic>) {
        return (nested['minimumStock'] as num?)?.toDouble();
      }
      return (json['minimumStock'] as num?)?.toDouble();
    }

    double? resolveMaximumStock() {
      final nested = json['customSupply'];
      if (nested is Map<String, dynamic>) {
        return (nested['maximumStock'] as num?)?.toDouble();
      }
      return (json['maximumStock'] as num?)?.toDouble();
    }

    return BatchResponseModel(
      id: value('id'),
      code: value('code'),
      currentStock: (json['currentStock'] as num?)?.toDouble() ?? 0.0,
      customSupplyId: resolveCustomSupplyId(),
      branchId: value('branchId'),
      customSupplyName: resolveCustomSupplyName(),
      unitMeasurementAbbreviation: resolveUnitAbbreviation(),
      minimumStock: resolveMinimumStock(),
      maximumStock: resolveMaximumStock(),
      expirationDate: json['expirationDate'] != null
          ? DateTime.tryParse(json['expirationDate'].toString())
          : null,
      entryDate: json['entryDate'] != null
          ? DateTime.tryParse(json['entryDate'].toString())
          : null,
    );
  }

  Batch toDomain() {
    return Batch(
      id: id,
      code: code,
      currentStock: currentStock,
      customSupplyId: customSupplyId,
      branchId: branchId,
      customSupplyName: customSupplyName,
      unitMeasurementAbbreviation: unitMeasurementAbbreviation,
      minimumStock: minimumStock,
      maximumStock: maximumStock,
      expirationDate: expirationDate,
      entryDate: entryDate,
    );
  }
}
