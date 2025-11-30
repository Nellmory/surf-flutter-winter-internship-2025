import '../../core/utils/result.dart';
import '../models/fruit_dto.dart';
import 'api_service.dart';

class RemoteDataSource {
  final ApiService apiService;

  RemoteDataSource(this.apiService);

  Future<Result<List<FruitDto>>> getAllFruits() async {
    try {
      final fruits = await apiService.getAllFruits();
      return Success(fruits);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}

