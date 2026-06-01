import 'package:dartz/dartz.dart';
import 'package:factory_management/core/error/failures.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/features/factory/domain/repositories/factory_repository.dart';

class GetFactoriesUsecase {
  final FactoryRepository _repository;
  GetFactoriesUsecase(this._repository);

  Future<Either<Failure, List<FactoryEntity>>> call({String? name, String? productName, String? category}) {
    return _repository.getFactories(name: name, productName: productName, category: category);
  }
}
