import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory_category/domain/repositories/category_repository.dart';

class DeleteCategoryUsecase {
  final CategoryRepository _repository;
  DeleteCategoryUsecase(this._repository);
  Future<Either<Failure, void>> call(int id) => _repository.deleteCategory(id);
}
