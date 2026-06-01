import 'package:equatable/equatable.dart';
import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}
class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryEntity> categories;
  const CategoryLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);
  @override
  List<Object?> get props => [message];
}

class CategoryActionSuccess extends CategoryState {
  final List<CategoryEntity> categories;
  final String message;
  const CategoryActionSuccess(this.categories, this.message);
  @override
  List<Object?> get props => [categories, message];
}
