import 'package:dio/dio.dart';
import 'package:factory_management/features/product/data/models/product_model.dart';

class ProductRemoteDatasource {
  final Dio _dio;
  ProductRemoteDatasource(this._dio);

  Future<List<ProductModel>> getProducts() async {
    final response = await _dio.get('/api/v1/products/');
    return (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<ProductModel> createProduct(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/v1/products/', data: data);
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await _dio.put('/api/v1/products/$id', data: data);
    return ProductModel.fromJson(response.data);
  }

  Future<void> deleteProduct(int id) async {
    await _dio.delete('/api/v1/products/$id');
  }
}
