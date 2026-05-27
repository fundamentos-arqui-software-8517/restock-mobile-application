import '../../domain/entities/custom_supply.dart';

/// A model class representing a custom supply response from the API.
class CustomSupplyResponseModel {

  /// The unique identifier for the custom supply.
  final String customSupplyId;

  /// The identifier for the account associated with the custom supply.
  final String accountId;

  /// The name of the custom supply.
  final String name;

  /// The category of the custom supply.
  final String category;

  /// The unit price of the custom supply.
  final double unitPrice;

  /// The unit of measure for the custom supply.
  final double unitOfMeasure;

  /// The URL of the image associated with the custom supply.
  final String imageUrl;

  /// The description of the custom supply.
  final String description;

  /// The minimum stock level for the custom supply.
  final double minStock;

  /// The maximum stock level for the custom supply.
  final double maxStock;

  /// The creation date of the custom supply.
  final String createdAt;

  /// Constructs a [CustomSupplyResponseModel] with the given parameters.
  const CustomSupplyResponseModel({
    required this.customSupplyId,
    required this.accountId,
    required this.name,
    required this.category,
    required this.unitPrice,
    required this.unitOfMeasure,
    required this.imageUrl,
    required this.description,
    required this.minStock,
    required this.maxStock,
    required this.createdAt,
  });

  /// Creates a [CustomSupplyResponseModel] from a JSON map.
  /// [json] The JSON map containing the custom supply data.
  /// Returns a [CustomSupplyResponseModel] instance created from the JSON data.
  factory CustomSupplyResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomSupplyResponseModel(
      customSupplyId: json['id'],
      accountId: json['accountId'],
      name: json['name'],
      category: json['category'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      unitOfMeasure: (json['unitOfMeasure'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      description: json['description'],
      minStock: (json['minStock'] as num).toDouble(),
      maxStock: (json['maxStock'] as num).toDouble(),
      createdAt: json['createdAt'],
    );
  }

  /// Converts this [CustomSupplyResponseModel] to a [CustomSupply] domain entity.
  /// Returns a [CustomSupply] instance with the same data as this model.
  CustomSupply toDomain() {
    return CustomSupply(
      customSupplyId: customSupplyId,
      accountId: accountId,
      name: name,
      category: category,
      unitPrice: unitPrice,
      unitOfMeasure: unitOfMeasure,
      imageUrl: imageUrl,
      description: description,
      minStock: minStock,
      maxStock: maxStock,
      createdAt: createdAt,
    );
  }
}