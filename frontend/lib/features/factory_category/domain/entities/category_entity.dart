import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String categoryName;

  const CategoryEntity({required this.id, required this.categoryName});

  @override
  List<Object?> get props => [id, categoryName];
}
