import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/product/domain/repositories/product_repository.dart';

class DeleteProductUsecase {
  final ProductRepository _repo;
  DeleteProductUsecase(this._repo);
  Future<Either<Failure, void>> call(int id) => _repo.deleteProduct(id);
}
