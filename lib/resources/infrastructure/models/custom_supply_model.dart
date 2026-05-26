import 'package:restock/resources/domain/entities/custom_supply.dart';

class CustomSupplyResponseModel extends CustomSupply {
  
  CustomSupplyResponseModel({
    required String accountId,
    required String name,
    required String category,
    required double unitPrice,
    required double unitOfMeasure,
    required String imageUrl,
    required String description,
    required double minStock,
    required double maxStock,
    required String createdAt,
  }) : super(
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

  factory CustomSupplyResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomSupplyResponseModel(
      accountId: json['accountId'],
      name: json['name'],
      category: json['category'],
      unitPrice: json['unitPrice'].toDouble(),
      unitOfMeasure: json['unitOfMeasure'].toDouble(),
      imageUrl: json['imageUrl'],
      description: json['description'],
      minStock: json['minStock'].toDouble(),
      maxStock: json['maxStock'].toDouble(),
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'name': name,
      'category': category,
      'unitPrice': unitPrice,
      'unitOfMeasure': unitOfMeasure,
      'imageUrl': imageUrl,
      'description': description,
      'minStock': minStock,
      'maxStock': maxStock,
      'createdAt': createdAt,
    };
  }

  CustomSupply toDomain() {
    return CustomSupply(
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
