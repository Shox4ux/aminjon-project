import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/product/domain/entities/product_entity.dart';
import 'package:factory_management/features/product/domain/repositories/product_repository.dart';

class GetProductsUsecase {
  final ProductRepository _repo;
  GetProductsUsecase(this._repo);
  Future<Either<Failure, List<ProductEntity>>> call() => _repo.getProducts();
}
