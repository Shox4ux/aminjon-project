import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, CategoryEntity>> createCategory(Map<String, dynamic> data);
  Future<Either<Failure, CategoryEntity>> updateCategory(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteCategory(int id);
}
