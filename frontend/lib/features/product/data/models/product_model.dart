import 'package:factory_management/features/product/domain/entities/product_entity.dart';
import 'package:factory_management/features/product/data/models/model_model.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.factoryId,
    super.models,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      factoryId: json['factory_id'],
      models: (json['models'] as List<dynamic>? ?? [])
          .map((m) => ModelModel.fromJson(m))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'factory_id': factoryId,
      };
}
