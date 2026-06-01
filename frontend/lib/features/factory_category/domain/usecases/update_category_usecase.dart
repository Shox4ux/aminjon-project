import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';
import 'package:factory_management/features/factory_category/domain/repositories/category_repository.dart';

class UpdateCategoryUsecase {
  final CategoryRepository _repository;
  UpdateCategoryUsecase(this._repository);
  Future<Either<Failure, CategoryEntity>> call(int id, Map<String, dynamic> data) => _repository.updateCategory(id, data);
}
