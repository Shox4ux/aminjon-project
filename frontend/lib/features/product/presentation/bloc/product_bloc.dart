import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/features/product/domain/usecases/get_products_usecase.dart';
import 'package:factory_management/features/product/domain/usecases/create_product_usecase.dart';
import 'package:factory_management/features/product/domain/usecases/update_product_usecase.dart';
import 'package:factory_management/features/product/domain/usecases/delete_product_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUsecase getProducts;
  final CreateProductUsecase createProduct;
  final UpdateProductUsecase updateProduct;
  final DeleteProductUsecase deleteProduct;

  ProductBloc({
    required this.getProducts,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_onLoad);
    on<CreateProduct>(_onCreate);
    on<UpdateProduct>(_onUpdate);
    on<DeleteProduct>(_onDelete);
  }

  Future<void> _onLoad(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getProducts();
    result.fold((f) => emit(ProductError(f.message)), (p) => emit(ProductLoaded(p)));
  }

  Future<void> _onCreate(CreateProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await createProduct(event.data);
    if (result.isLeft()) {
      result.fold((f) => emit(ProductError(f.message)), (_) {});
      return;
    }
    final listResult = await getProducts();
    listResult.fold(
      (f) => emit(ProductError(f.message)),
      (products) => emit(ProductActionSuccess(products, 'Product created successfully')),
    );
  }

  Future<void> _onUpdate(UpdateProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await updateProduct(event.id, event.data);
    if (result.isLeft()) {
      result.fold((f) => emit(ProductError(f.message)), (_) {});
      return;
    }
    final listResult = await getProducts();
    listResult.fold(
      (f) => emit(ProductError(f.message)),
      (products) => emit(ProductActionSuccess(products, 'Product updated successfully')),
    );
  }

  Future<void> _onDelete(DeleteProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await deleteProduct(event.id);
    if (result.isLeft()) {
      result.fold((f) => emit(ProductError(f.message)), (_) {});
      return;
    }
    final listResult = await getProducts();
    listResult.fold(
      (f) => emit(ProductError(f.message)),
      (products) => emit(ProductActionSuccess(products, 'Product deleted')),
    );
  }
}
