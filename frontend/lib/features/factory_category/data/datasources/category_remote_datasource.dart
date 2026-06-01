import 'package:dio/dio.dart';
import 'package:factory_management/features/factory_category/data/models/category_model.dart';

class CategoryRemoteDatasource {
  final Dio _dio;
  CategoryRemoteDatasource(this._dio);

  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get('/api/v1/categories/');
    return (response.data as List).map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<CategoryModel> createCategory(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/v1/categories/', data: data);
    return CategoryModel.fromJson(response.data);
  }

  Future<CategoryModel> updateCategory(int id, Map<String, dynamic> data) async {
    final response = await _dio.put('/api/v1/categories/$id', data: data);
    return CategoryModel.fromJson(response.data);
  }

  Future<void> deleteCategory(int id) async {
    await _dio.delete('/api/v1/categories/$id');
  }
}
