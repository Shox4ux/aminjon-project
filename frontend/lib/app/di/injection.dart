import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:factory_management/core/network/dio_client.dart';

// Factory
import 'package:factory_management/features/factory/data/datasources/factory_remote_datasource.dart';
import 'package:factory_management/features/factory/data/repositories/factory_repository_impl.dart';
import 'package:factory_management/features/factory/domain/repositories/factory_repository.dart';
import 'package:factory_management/features/factory/domain/usecases/get_factories_usecase.dart';
import 'package:factory_management/features/factory/domain/usecases/create_factory_usecase.dart';
import 'package:factory_management/features/factory/domain/usecases/update_factory_usecase.dart';
import 'package:factory_management/features/factory/domain/usecases/delete_factory_usecase.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_bloc.dart';

// Product
import 'package:factory_management/features/product/data/datasources/product_remote_datasource.dart';
import 'package:factory_management/features/product/data/repositories/product_repository_impl.dart';
import 'package:factory_management/features/product/domain/repositories/product_repository.dart';
import 'package:factory_management/features/product/domain/usecases/get_products_usecase.dart';
import 'package:factory_management/features/product/domain/usecases/create_product_usecase.dart';
import 'package:factory_management/features/product/domain/usecases/update_product_usecase.dart';
import 'package:factory_management/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:factory_management/features/product/presentation/bloc/product_bloc.dart';

// Category
import 'package:factory_management/features/factory_category/data/datasources/category_remote_datasource.dart';
import 'package:factory_management/features/factory_category/data/repositories/category_repository_impl.dart';
import 'package:factory_management/features/factory_category/domain/repositories/category_repository.dart';
import 'package:factory_management/features/factory_category/domain/usecases/get_categories_usecase.dart';
import 'package:factory_management/features/factory_category/domain/usecases/create_category_usecase.dart';
import 'package:factory_management/features/factory_category/domain/usecases/update_category_usecase.dart';
import 'package:factory_management/features/factory_category/domain/usecases/delete_category_usecase.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_bloc.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // Core
  sl.registerLazySingleton<Dio>(() => DioClient.create());

  // ── Factory ──
  sl.registerLazySingleton<FactoryRemoteDatasource>(() => FactoryRemoteDatasource(sl()));
  sl.registerLazySingleton<FactoryRepository>(() => FactoryRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetFactoriesUsecase(sl()));
  sl.registerLazySingleton(() => CreateFactoryUsecase(sl()));
  sl.registerLazySingleton(() => UpdateFactoryUsecase(sl()));
  sl.registerLazySingleton(() => DeleteFactoryUsecase(sl()));
  sl.registerFactory(() => FactoryBloc(
        getFactories: sl(),
        createFactory: sl(),
        updateFactory: sl(),
        deleteFactory: sl(),
      ));

  // ── Product ──
  sl.registerLazySingleton<ProductRemoteDatasource>(() => ProductRemoteDatasource(sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProductsUsecase(sl()));
  sl.registerLazySingleton(() => CreateProductUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));
  sl.registerFactory(() => ProductBloc(
        getProducts: sl(),
        createProduct: sl(),
        updateProduct: sl(),
        deleteProduct: sl(),
      ));

  // ── Category ──
  sl.registerLazySingleton<CategoryRemoteDatasource>(() => CategoryRemoteDatasource(sl()));
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => CreateCategoryUsecase(sl()));
  sl.registerLazySingleton(() => UpdateCategoryUsecase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUsecase(sl()));
  sl.registerFactory(() => CategoryBloc(
        getCategories: sl(),
        createCategory: sl(),
        updateCategory: sl(),
        deleteCategory: sl(),
      ));
}
