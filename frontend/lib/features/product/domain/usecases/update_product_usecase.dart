import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/product/domain/entities/product_entity.dart';
import 'package:factory_management/features/product/domain/repositories/product_repository.dart';

class UpdateProductUsecase {
  final ProductRepository _repo;
  UpdateProductUsecase(this._repo);
  Future<Either<Failure, ProductEntity>> call(int id, Map<String, dynamic> data) => _repo.updateProduct(id, data);
}
