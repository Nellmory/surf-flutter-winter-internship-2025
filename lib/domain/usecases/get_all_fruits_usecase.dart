import '../../core/utils/result.dart';
import '../../domain/models/fruit.dart';
import '../../domain/repositories/fruit_repository.dart';

class GetAllFruitsUseCase {
  final FruitRepository repository;

  GetAllFruitsUseCase(this.repository);

  Future<Result<List<Fruit>>> call() async {
    return await repository.getAllFruits();
  }
}

