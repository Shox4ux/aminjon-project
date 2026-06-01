import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/product/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, ProductEntity>> createProduct(Map<String, dynamic> data);
  Future<Either<Failure, ProductEntity>> updateProduct(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteProduct(int id);
}
