import 'package:equatable/equatable.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';

abstract class FactoryState extends Equatable {
  const FactoryState();
  @override
  List<Object?> get props => [];
}

class FactoryInitial extends FactoryState {}

class FactoryLoading extends FactoryState {}

class FactoryLoaded extends FactoryState {
  final List<FactoryEntity> factories;
  const FactoryLoaded(this.factories);
  @override
  List<Object?> get props => [factories];
}

class FactoryError extends FactoryState {
  final String message;
  const FactoryError(this.message);
  @override
  List<Object?> get props => [message];
}

class FactoryActionSuccess extends FactoryState {
  final List<FactoryEntity> factories;
  final String message;
  const FactoryActionSuccess(this.factories, this.message);
  @override
  List<Object?> get props => [factories, message];
}
