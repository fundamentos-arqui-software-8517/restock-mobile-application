///
/// This class represents a custom supply entity in the application. It contains all the necessary information about a custom supply, such as its ID, account ID, name, category, unit price, unit of measure, image URL, description, minimum stock, maximum stock, and creation date.
/// 
class CustomSupply {

  /// The unique identifier for the custom supply.
  final String customSupplyId;

  /// The identifier for the account that owns this custom supply.
  final String accountId;

  /// The name of the custom supply.
  final String name;

  /// The category to which the custom supply belongs.
  final String category;

  /// The price per unit of the custom supply.
  final double unitPrice;

  // The unit of measure for the custom supply (e.g., pieces, kilograms, liters).
  final double unitOfMeasure;

  /// The URL of the image representing the custom supply.
  final String imageUrl;

  /// A description of the custom supply.
  final String description;

  /// The minimum stock level for the custom supply.
  final double minStock;

  /// The maximum stock level for the custom supply.
  final double maxStock;

  /// The date and time when the custom supply was created.
  final String createdAt;

  /// The constructor for the CustomSupply class, which initializes all the required fields.
  /// 
  /// [customSupplyId] is the unique identifier for the custom supply.
  /// [accountId] is the identifier for the account that owns this custom supply.
  /// [name] is the name of the custom supply.
  /// [category] is the category to which the custom supply belongs.
  /// [unitPrice] is the price per unit of the custom supply.
  /// [unitOfMeasure] is the unit of measure for the custom supply (e.g., pieces, kilograms, liters).
  /// [imageUrl] is the URL of the image representing the custom supply.
  /// [description] is a description of the custom supply.
  /// [minStock] is the minimum stock level for the custom supply.
  /// [maxStock] is the maximum stock level for the custom supply.
  /// [createdAt] is the date and time when the custom supply was created.
  CustomSupply({
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

  
}
