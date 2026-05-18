import 'package:factory_management/features/product/domain/entities/model_entity.dart';

class ModelModel extends ModelEntity {
  const ModelModel({
    required super.id,
    required super.name,
    required super.price,
    required super.info,
    super.images,
    required super.productId,
  });

  factory ModelModel.fromJson(Map<String, dynamic> json) {
    return ModelModel(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      info: json['info'],
      images: json['images'],
      productId: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'info': info,
        'images': images,
        'product_id': productId,
      };
}
