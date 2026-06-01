import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';
import 'package:factory_management/features/factory_category/domain/repositories/category_repository.dart';

class CreateCategoryUsecase {
  final CategoryRepository _repository;
  CreateCategoryUsecase(this._repository);
  Future<Either<Failure, CategoryEntity>> call(Map<String, dynamic> data) => _repository.createCategory(data);
}
