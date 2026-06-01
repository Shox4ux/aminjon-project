import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';
import 'package:factory_management/features/factory_category/domain/repositories/category_repository.dart';

class GetCategoriesUsecase {
  final CategoryRepository _repository;
  GetCategoriesUsecase(this._repository);
  Future<Either<Failure, List<CategoryEntity>>> call() => _repository.getCategories();
}
