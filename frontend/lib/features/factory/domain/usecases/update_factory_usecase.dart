import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/features/factory/domain/repositories/factory_repository.dart';

class UpdateFactoryUsecase {
  final FactoryRepository _repository;
  UpdateFactoryUsecase(this._repository);

  Future<Either<Failure, FactoryEntity>> call(int id, Map<String, dynamic> data) {
    return _repository.updateFactory(id, data);
  }
}
