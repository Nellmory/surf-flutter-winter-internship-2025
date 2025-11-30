import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/fruit_dto.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<FruitDto>> getAllFruits() async {
    try {
      final response = await _dio.get(ApiConstants.allFruitsEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => FruitDto.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load fruits: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching fruits: $e');
    }
  }
}

