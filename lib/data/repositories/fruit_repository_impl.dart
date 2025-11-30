import '../../core/utils/result.dart';
import '../../domain/models/fruit.dart';
import '../../domain/models/recipe.dart';
import '../../domain/repositories/fruit_repository.dart';
import '../remote/remote_data_source.dart';
import '../local/local_data_source.dart';
import '../mapper/fruit_mapper.dart';
import '../local/recipe_entity.dart';

class FruitRepositoryImpl implements FruitRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  FruitRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<List<Fruit>>> getAllFruits() async {
    try {
      final result = await remoteDataSource.getAllFruits();
      switch (result) {
        case Success(data: final fruitsDto):
          final fruits = FruitMapper.toDomainList(fruitsDto);
          return Success(fruits);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<int>>> getFavoriteFruitIds() async {
    return await localDataSource.getFavoriteFruitIds();
  }

  @override
  Future<Result<bool>> isFavorite(int fruitId) async {
    return await localDataSource.isFavorite(fruitId);
  }

  @override
  Future<Result<void>> addToFavorites(int fruitId) async {
    return await localDataSource.addToFavorites(fruitId);
  }

  @override
  Future<Result<void>> removeFromFavorites(int fruitId) async {
    return await localDataSource.removeFromFavorites(fruitId);
  }

  @override
  Future<Result<List<Recipe>>> getAllRecipes() async {
    try {
      final result = await localDataSource.getAllRecipes();
      switch (result) {
        case Success(data: final recipeEntities):
          final recipes = recipeEntities.map((entity) => Recipe(
            id: entity.id,
            name: entity.name,
            description: entity.description,
            fruitIds: entity.fruitIds,
          )).toList();
          return Success(recipes);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<Recipe?>> getRecipeById(String id) async {
    try {
      final result = await localDataSource.getRecipeById(id);
      switch (result) {
        case Success(data: final entity?):
          return Success(Recipe(
            id: entity.id,
            name: entity.name,
            description: entity.description,
            fruitIds: entity.fruitIds,
          ));
        case Success(data: null):
          return const Success(null);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> saveRecipe(Recipe recipe) async {
    try {
      final entity = RecipeEntity(
        id: recipe.id,
        name: recipe.name,
        description: recipe.description,
        fruitIds: recipe.fruitIds,
      );
      return await localDataSource.saveRecipe(entity);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteRecipe(String id) async {
    return await localDataSource.deleteRecipe(id);
  }
}

