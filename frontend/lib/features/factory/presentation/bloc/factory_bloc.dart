import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/features/factory/domain/usecases/get_factories_usecase.dart';
import 'package:factory_management/features/factory/domain/usecases/create_factory_usecase.dart';
import 'package:factory_management/features/factory/domain/usecases/update_factory_usecase.dart';
import 'package:factory_management/features/factory/domain/usecases/delete_factory_usecase.dart';
import 'factory_event.dart';
import 'factory_state.dart';

class FactoryBloc extends Bloc<FactoryEvent, FactoryState> {
  final GetFactoriesUsecase getFactories;
  final CreateFactoryUsecase createFactory;
  final UpdateFactoryUsecase updateFactory;
  final DeleteFactoryUsecase deleteFactory;

  FactoryBloc({
    required this.getFactories,
    required this.createFactory,
    required this.updateFactory,
    required this.deleteFactory,
  }) : super(FactoryInitial()) {
    on<LoadFactories>(_onLoad);
    on<CreateFactory>(_onCreate);
    on<UpdateFactory>(_onUpdate);
    on<DeleteFactory>(_onDelete);
  }

  Future<void> _onLoad(LoadFactories event, Emitter<FactoryState> emit) async {
    emit(FactoryLoading());
    final result = await getFactories(name: event.name, productName: event.productName, category: event.category);
    result.fold(
      (f) => emit(FactoryError(f.message)),
      (factories) => emit(FactoryLoaded(factories)),
    );
  }

  Future<void> _onCreate(CreateFactory event, Emitter<FactoryState> emit) async {
    emit(FactoryLoading());
    final result = await createFactory(event.data);
    if (result.isLeft()) {
      result.fold((f) => emit(FactoryError(f.message)), (_) {});
      return;
    }
    final listResult = await getFactories();
    listResult.fold(
      (f) => emit(FactoryError(f.message)),
      (factories) => emit(FactoryActionSuccess(factories, 'Factory created successfully')),
    );
  }

  Future<void> _onUpdate(UpdateFactory event, Emitter<FactoryState> emit) async {
    emit(FactoryLoading());
    final result = await updateFactory(event.id, event.data);
    if (result.isLeft()) {
      result.fold((f) => emit(FactoryError(f.message)), (_) {});
      return;
    }
    final listResult = await getFactories();
    listResult.fold(
      (f) => emit(FactoryError(f.message)),
      (factories) => emit(FactoryActionSuccess(factories, 'Factory updated successfully')),
    );
  }

  Future<void> _onDelete(DeleteFactory event, Emitter<FactoryState> emit) async {
    emit(FactoryLoading());
    final result = await deleteFactory(event.id);
    if (result.isLeft()) {
      result.fold((f) => emit(FactoryError(f.message)), (_) {});
      return;
    }
    final listResult = await getFactories();
    listResult.fold(
      (f) => emit(FactoryError(f.message)),
      (factories) => emit(FactoryActionSuccess(factories, 'Factory deleted')),
    );
  }
}
