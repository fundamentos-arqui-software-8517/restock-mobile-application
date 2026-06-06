import 'package:restock/resources/domain/entities/supply.dart';

/// Response model for the base supply nested in a custom supply response.
class SupplyResponseModel {
  const SupplyResponseModel({
    required this.supplyId,
    required this.name,
    required this.description,
    required this.category,
    required this.isPerishable,
  });

  final String supplyId;
  final String name;
  final String description;
  final String category;
  final bool isPerishable;

  factory SupplyResponseModel.fromJson(Map<String, dynamic> json) {
    String value(String key, {String fallback = ''}) {
      return json[key]?.toString() ?? fallback;
    }

    bool boolValue(Object? value) {
      if (value is bool) return value;
      return value?.toString().toLowerCase() == 'true';
    }

    return SupplyResponseModel(
      supplyId: value('id'),
      name: value('name'),
      description: value('description'),
      category: value('category'),
      isPerishable: boolValue(json['isPerishable']),
    );
  }

  Supply toDomain() {
    return Supply(
      supplyId: supplyId,
      name: name,
      description: description,
      category: category,
      isPerishable: isPerishable,
    );
  }
}
