import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/features/factory_category/data/models/category_model.dart';
import 'package:factory_management/features/product/data/models/product_model.dart';

class FactoryModel extends FactoryEntity {
  const FactoryModel({
    required super.id,
    required super.name,
    super.phone,
    super.wechatId,
    super.address,
    required super.factoryCategoryId,
    super.factoryCategory,
    super.products,
  });

  factory FactoryModel.fromJson(Map<String, dynamic> json) {
    return FactoryModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      wechatId: json['wechat_id'],
      address: json['address'],
      factoryCategoryId: json['factory_category_id'],
      factoryCategory: json['factory_category'] != null
          ? CategoryModel.fromJson(json['factory_category'])
          : null,
      products: (json['products'] as List<dynamic>? ?? [])
          .map((p) => ProductModel.fromJson(p))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'wechat_id': wechatId,
        'address': address,
        'factory_category_id': factoryCategoryId,
      };
}
