import 'package:equatable/equatable.dart';

class ModelEntity extends Equatable {
  final int id;
  final String name;
  final double price;
  final String info;
  final String? images;
  final int productId;

  const ModelEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.info,
    this.images,
    required this.productId,
  });

  @override
  List<Object?> get props => [id, name, price, productId];
}
