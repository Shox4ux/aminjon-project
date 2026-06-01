import 'package:equatable/equatable.dart';
import 'package:factory_management/features/product/domain/entities/model_entity.dart';

class ProductEntity extends Equatable {
  final int id;
  final String name;
  final int factoryId;
  final List<ModelEntity> models;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.factoryId,
    this.models = const [],
  });

  @override
  List<Object?> get props => [id, name, factoryId];
}
