import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.id, required super.categoryName});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], categoryName: json['category_name']);
  }

  Map<String, dynamic> toJson() => {'category_name': categoryName};
}
