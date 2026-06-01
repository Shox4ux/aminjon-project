import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';

abstract class FactoryRepository {
  Future<Either<Failure, List<FactoryEntity>>> getFactories({String? name, String? productName, String? category});
  Future<Either<Failure, FactoryEntity>> createFactory(Map<String, dynamic> data);
  Future<Either<Failure, FactoryEntity>> updateFactory(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteFactory(int id);
}
