import 'package:dio/dio.dart';
import 'package:factory_management/features/factory/data/models/factory_model.dart';

class FactoryRemoteDatasource {
  final Dio _dio;
  FactoryRemoteDatasource(this._dio);

  Future<List<FactoryModel>> getFactories({String? name, String? productName, String? category}) async {
    final params = <String, dynamic>{};
    if (name != null && name.isNotEmpty) params['name'] = name;
    if (productName != null && productName.isNotEmpty) params['product_name'] = productName;
    if (category != null && category.isNotEmpty) params['category'] = category;

    final response = await _dio.get('/api/v1/factories/', queryParameters: params);
    return (response.data as List).map((e) => FactoryModel.fromJson(e)).toList();
  }

  Future<FactoryModel> createFactory(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/v1/factories/', data: data);
    return FactoryModel.fromJson(response.data);
  }

  Future<FactoryModel> updateFactory(int id, Map<String, dynamic> data) async {
    final response = await _dio.put('/api/v1/factories/$id', data: data);
    return FactoryModel.fromJson(response.data);
  }

  Future<void> deleteFactory(int id) async {
    await _dio.delete('/api/v1/factories/$id');
  }
}
