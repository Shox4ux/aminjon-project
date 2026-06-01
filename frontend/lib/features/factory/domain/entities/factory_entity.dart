import 'package:equatable/equatable.dart';
import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';
import 'package:factory_management/features/product/domain/entities/product_entity.dart';

class FactoryEntity extends Equatable {
  final int id;
  final String name;
  final String? phone;
  final String? wechatId;
  final String? address;
  final int factoryCategoryId;
  final CategoryEntity? factoryCategory;
  final List<ProductEntity> products;

  const FactoryEntity({
    required this.id,
    required this.name,
    this.phone,
    this.wechatId,
    this.address,
    required this.factoryCategoryId,
    this.factoryCategory,
    this.products = const [],
  });

  @override
  List<Object?> get props => [id, name, phone, wechatId, address, factoryCategoryId];
}
