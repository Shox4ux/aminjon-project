import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory/data/datasources/factory_remote_datasource.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/features/factory/domain/repositories/factory_repository.dart';

bool _isNetworkError(DioException e) =>
    e.type == DioExceptionType.connectionTimeout ||
    e.type == DioExceptionType.receiveTimeout ||
    e.type == DioExceptionType.connectionError;

class FactoryRepositoryImpl implements FactoryRepository {
  final FactoryRemoteDatasource _datasource;
  FactoryRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<FactoryEntity>>> getFactories({String? name, String? productName, String? category}) async {
    try {
      final result = await _datasource.getFactories(name: name, productName: productName, category: category);
      return Right(result);
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, FactoryEntity>> createFactory(Map<String, dynamic> data) async {
    try {
      return Right(await _datasource.createFactory(data));
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, FactoryEntity>> updateFactory(int id, Map<String, dynamic> data) async {
    try {
      return Right(await _datasource.updateFactory(id, data));
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFactory(int id) async {
    try {
      await _datasource.deleteFactory(id);
      return const Right(null);
    } on DioException catch (e) {
      if (_isNetworkError(e)) { return const Left(NetworkFailure()); }
      return Left(ServerFailure(e.response?.data?['detail'] ?? e.message ?? 'Server error'));
    }
  }
}
