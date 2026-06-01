import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/features/factory_category/domain/usecases/get_categories_usecase.dart';
import 'package:factory_management/features/factory_category/domain/usecases/create_category_usecase.dart';
import 'package:factory_management/features/factory_category/domain/usecases/update_category_usecase.dart';
import 'package:factory_management/features/factory_category/domain/usecases/delete_category_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUsecase getCategories;
  final CreateCategoryUsecase createCategory;
  final UpdateCategoryUsecase updateCategory;
  final DeleteCategoryUsecase deleteCategory;

  CategoryBloc({
    required this.getCategories,
    required this.createCategory,
    required this.updateCategory,
    required this.deleteCategory,
  }) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoad);
    on<CreateCategory>(_onCreate);
    on<UpdateCategory>(_onUpdate);
    on<DeleteCategory>(_onDelete);
  }

  Future<void> _onLoad(LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await getCategories();
    result.fold(
      (f) => emit(CategoryError(f.message)),
      (cats) => emit(CategoryLoaded(cats)),
    );
  }

  Future<void> _onCreate(CreateCategory event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await createCategory(event.data);
    if (result.isLeft()) {
      result.fold((f) => emit(CategoryError(f.message)), (_) {});
      return;
    }
    final listResult = await getCategories();
    listResult.fold(
      (f) => emit(CategoryError(f.message)),
      (cats) => emit(CategoryActionSuccess(cats, 'Category created successfully')),
    );
  }

  Future<void> _onUpdate(UpdateCategory event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await updateCategory(event.id, event.data);
    if (result.isLeft()) {
      result.fold((f) => emit(CategoryError(f.message)), (_) {});
      return;
    }
    final listResult = await getCategories();
    listResult.fold(
      (f) => emit(CategoryError(f.message)),
      (cats) => emit(CategoryActionSuccess(cats, 'Category updated successfully')),
    );
  }

  Future<void> _onDelete(DeleteCategory event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await deleteCategory(event.id);
    if (result.isLeft()) {
      result.fold((f) => emit(CategoryError(f.message)), (_) {});
      return;
    }
    final listResult = await getCategories();
    listResult.fold(
      (f) => emit(CategoryError(f.message)),
      (cats) => emit(CategoryActionSuccess(cats, 'Category deleted')),
    );
  }
}
