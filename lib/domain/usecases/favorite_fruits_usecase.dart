import '../../core/utils/result.dart';
import '../../domain/repositories/fruit_repository.dart';

class GetFavoriteFruitIdsUseCase {
  final FruitRepository repository;

  GetFavoriteFruitIdsUseCase(this.repository);

  Future<Result<List<int>>> call() async {
    return await repository.getFavoriteFruitIds();
  }
}

class IsFavoriteUseCase {
  final FruitRepository repository;

  IsFavoriteUseCase(this.repository);

  Future<Result<bool>> call(int fruitId) async {
    return await repository.isFavorite(fruitId);
  }
}

class AddToFavoritesUseCase {
  final FruitRepository repository;

  AddToFavoritesUseCase(this.repository);

  Future<Result<void>> call(int fruitId) async {
    return await repository.addToFavorites(fruitId);
  }
}

class RemoveFromFavoritesUseCase {
  final FruitRepository repository;

  RemoveFromFavoritesUseCase(this.repository);

  Future<Result<void>> call(int fruitId) async {
    return await repository.removeFromFavorites(fruitId);
  }
}

