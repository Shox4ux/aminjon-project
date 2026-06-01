import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory/domain/repositories/factory_repository.dart';

class DeleteFactoryUsecase {
  final FactoryRepository _repository;
  DeleteFactoryUsecase(this._repository);

  Future<Either<Failure, void>> call(int id) {
    return _repository.deleteFactory(id);
  }
}
