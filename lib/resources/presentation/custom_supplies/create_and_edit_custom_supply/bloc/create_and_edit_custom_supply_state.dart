import 'package:image_picker/image_picker.dart';
import 'package:restock/resources/domain/entities/supply.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class CreateCustomSupplyState {
  const CreateCustomSupplyState({
    this.status = Status.initial,
    this.customSupplyId,
    this.name = '',
    this.category = '',
    this.supplyId = '',
    this.supply,
    this.minimumStock = '',
    this.maximumStock = '',
    this.unitPrice = '',
    this.currency = 'PEN',
    this.unit = 'kg',
    this.description = '',
    this.pictureUrl = '',
    this.image,
    this.errorMessage,
    this.submitted = false,
  });

  final Status status;
  final String? customSupplyId;
  final String name;
  final String category;
  final String supplyId;
  final Supply? supply;
  final String minimumStock;
  final String maximumStock;
  final String unitPrice;
  final String currency;
  final String unit;
  final String description;
  final String pictureUrl;
  final XFile? image;
  final String? errorMessage;
  final bool submitted;

  bool get isValid =>
      nameError == null &&
      supplyError == null &&
      minimumStockError == null &&
      maximumStockError == null &&
      unitPriceError == null &&
      descriptionError == null;

  String? get nameError {
    if (!submitted) return null;
    if (name.trim().isEmpty) return 'Supply name is required';
    return null;
  }

  String? get supplyError {
    if (!submitted) return null;
    if (supplyId.trim().isEmpty) return 'Select a base supply';
    return null;
  }

  String? get minimumStockError {
    if (!submitted) return null;
    if (minimumStock.trim().isEmpty) return 'Minimum stock is required';
    final minimum = int.tryParse(minimumStock);
    if (minimum == null) return 'Enter a whole number';

    final maximum = int.tryParse(maximumStock);
    if (maximum != null && minimum == maximum) {
      return 'Minimum and maximum cannot be equal';
    }

    if (maximum != null && minimum > maximum) {
      return 'Minimum cannot be greater than maximum';
    }

    return null;
  }

  String? get maximumStockError {
    if (!submitted) return null;
    if (maximumStock.trim().isEmpty) return 'Maximum stock is required';
    final maximum = int.tryParse(maximumStock);
    if (maximum == null) return 'Enter a whole number';

    final minimum = int.tryParse(minimumStock);
    if (minimum != null && maximum == minimum) {
      return 'Maximum and minimum cannot be equal';
    }

    if (minimum != null && maximum < minimum) {
      return 'Maximum must be greater than minimum';
    }

    return null;
  }

  String? get unitPriceError {
    if (!submitted) return null;
    if (unitPrice.trim().isEmpty) return 'Unit price is required';
    if (int.tryParse(unitPrice) == null) return 'Enter a whole number';
    return null;
  }

  String? get descriptionError {
    if (!submitted) return null;
    if (description.trim().isEmpty) return 'Description is required';
    return null;
  }

  bool get isEditing => customSupplyId != null;

  String get unitMeasurement => switch (unit) {
    'kg' => 'Kilograms',
    'l' => 'Liters',
    'dozen' => 'Dozen',
    'g' => 'Grams',
    'unit' => 'Units',
    _ => unit,
  };

  CreateCustomSupplyState copyWith({
    Status? status,
    String? customSupplyId,
    String? name,
    String? category,
    String? supplyId,
    Supply? supply,
    String? minimumStock,
    String? maximumStock,
    String? unitPrice,
    String? currency,
    String? unit,
    String? description,
    String? pictureUrl,
    XFile? image,
    String? errorMessage,
    bool? submitted,
  }) {
    return CreateCustomSupplyState(
      status: status ?? this.status,
      customSupplyId: customSupplyId ?? this.customSupplyId,
      name: name ?? this.name,
      category: category ?? this.category,
      supplyId: supplyId ?? this.supplyId,
      supply: supply ?? this.supply,
      minimumStock: minimumStock ?? this.minimumStock,
      maximumStock: maximumStock ?? this.maximumStock,
      unitPrice: unitPrice ?? this.unitPrice,
      currency: currency ?? this.currency,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      image: image ?? this.image,
      errorMessage: errorMessage ?? this.errorMessage,
      submitted: submitted ?? this.submitted,
    );
  }
}
