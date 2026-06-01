import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/product/domain/entities/product_entity.dart';
import 'package:factory_management/features/product/domain/repositories/product_repository.dart';

class CreateProductUsecase {
  final ProductRepository _repo;
  CreateProductUsecase(this._repo);
  Future<Either<Failure, ProductEntity>> call(Map<String, dynamic> data) => _repo.createProduct(data);
}
