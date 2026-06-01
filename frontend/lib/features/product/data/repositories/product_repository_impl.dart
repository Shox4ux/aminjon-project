import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/product/data/datasources/product_remote_datasource.dart';
import 'package:factory_management/features/product/domain/entities/product_entity.dart';
import 'package:factory_management/features/product/domain/repositories/product_repository.dart';

bool _isNetworkError(DioException e) =>
    e.type == DioExceptionType.connectionTimeout ||
    e.type == DioExceptionType.receiveTimeout ||
    e.type == DioExceptionType.connectionError;

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource _datasource;
  ProductRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      return Right(await _datasource.getProducts());
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> createProduct(Map<String, dynamic> data) async {
    try {
      return Right(await _datasource.createProduct(data));
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      return Right(await _datasource.updateProduct(id, data));
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      await _datasource.deleteProduct(id);
      return const Right(null);
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }
}
