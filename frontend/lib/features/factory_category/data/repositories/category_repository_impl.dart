import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory_category/data/datasources/category_remote_datasource.dart';
import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';
import 'package:factory_management/features/factory_category/domain/repositories/category_repository.dart';

bool _isNetworkError(DioException e) =>
    e.type == DioExceptionType.connectionTimeout ||
    e.type == DioExceptionType.receiveTimeout ||
    e.type == DioExceptionType.connectionError;

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource _datasource;
  CategoryRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      return Right(await _datasource.getCategories());
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> createCategory(Map<String, dynamic> data) async {
    try {
      return Right(await _datasource.createCategory(data));
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory(int id, Map<String, dynamic> data) async {
    try {
      return Right(await _datasource.updateCategory(id, data));
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await _datasource.deleteCategory(id);
      return const Right(null);
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }
}
