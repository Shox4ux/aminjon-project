import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/features/factory/domain/repositories/factory_repository.dart';

class CreateFactoryUsecase {
  final FactoryRepository _repository;
  CreateFactoryUsecase(this._repository);

  Future<Either<Failure, FactoryEntity>> call(Map<String, dynamic> data) {
    return _repository.createFactory(data);
  }
}
