import 'package:restock/resources/domain/entities/batch.dart';

/// Response model for `/api/v1/batches`.
class BatchResponseModel {
  const BatchResponseModel({
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

  factory BatchResponseModel.fromJson(Map<String, dynamic> json) {
    String value(String key, {String fallback = ''}) {
      return json[key]?.toString() ?? fallback;
    }

    String nestedValue(Map<String, dynamic>? source, String key) {
      return source?[key]?.toString() ?? '';
    }

    double doubleValue(Object? value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    DateTime? dateValue(String key) {
      final value = json[key]?.toString();
      if (value == null || value.isEmpty) return null;
      return DateTime.tryParse(value);
    }

    final customSupply = json['customSupply'] is Map
        ? Map<String, dynamic>.from(json['customSupply'] as Map)
        : null;
    final supply = json['supply'] is Map
        ? Map<String, dynamic>.from(json['supply'] as Map)
        : null;
    final stockRange = json['stockRange'] is Map
        ? Map<String, dynamic>.from(json['stockRange'] as Map)
        : null;

    final customSupplyName = value(
      'customSupplyName',
      fallback: nestedValue(customSupply, 'name'),
    );

    return BatchResponseModel(
      id: value('id', fallback: value('_id')),
      code: value('code'),
      currentStock: doubleValue(json['currentStock']),
      unitMeasurement: value(
        'unitMeasurement',
        fallback: nestedValue(stockRange, 'unitMeasurement'),
      ),
      unitMeasurementAbbreviation: value(
        'unitMeasurementAbbreviation',
        fallback: nestedValue(stockRange, 'unitMeasurementAbbreviation'),
      ),
      customSupplyId: value(
        'customSupplyId',
        fallback: nestedValue(customSupply, 'id').isNotEmpty
            ? nestedValue(customSupply, 'id')
            : nestedValue(customSupply, '_id'),
      ),
      branchId: value('branchId'),
      accountId: value('accountId'),
      customSupplyName: customSupplyName.isEmpty
          ? nestedValue(supply, 'name')
          : customSupplyName,
      minimumStock: json.containsKey('minimumStock')
          ? doubleValue(json['minimumStock'])
          : stockRange == null
          ? null
          : doubleValue(stockRange['minimumStock']),
      maximumStock: json.containsKey('maximumStock')
          ? doubleValue(json['maximumStock'])
          : stockRange == null
          ? null
          : doubleValue(stockRange['maximumStock']),
      pictureUrl: value(
        'pictureUrl',
        fallback: nestedValue(customSupply, 'pictureUrl'),
      ),
      expirationDate: dateValue('expirationDate'),
      entryDate: dateValue('entryDate'),
    );
  }

  Batch toDomain() {
    return Batch(
      id: id,
      code: code,
      currentStock: currentStock,
      unitMeasurement: unitMeasurement,
      unitMeasurementAbbreviation: unitMeasurementAbbreviation,
      customSupplyId: customSupplyId,
      branchId: branchId,
      accountId: accountId,
      customSupplyName: customSupplyName,
      minimumStock: minimumStock,
      maximumStock: maximumStock,
      pictureUrl: pictureUrl,
      expirationDate: expirationDate,
      entryDate: entryDate,
    );
  }
}
