import '../../core/utils/result.dart';
import 'hive_service.dart';
import 'recipe_entity.dart';

class LocalDataSource {
  // Избранное
  Future<Result<List<int>>> getFavoriteFruitIds() async {
    try {
      final box = HiveService.favoriteFruitsBox;
      return Success(box.values.toList());
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<bool>> isFavorite(int fruitId) async {
    try {
      final box = HiveService.favoriteFruitsBox;
      return Success(box.containsKey(fruitId));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void>> addToFavorites(int fruitId) async {
    try {
      final box = HiveService.favoriteFruitsBox;
      await box.put(fruitId, fruitId);
      return const Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void>> removeFromFavorites(int fruitId) async {
    try {
      final box = HiveService.favoriteFruitsBox;
      await box.delete(fruitId);
      return const Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  // Рецепты
  Future<Result<List<RecipeEntity>>> getAllRecipes() async {
    try {
      final box = HiveService.recipesBox;
      return Success(box.values.toList());
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<RecipeEntity?>> getRecipeById(String id) async {
    try {
      final box = HiveService.recipesBox;
      return Success(box.get(id));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void>> saveRecipe(RecipeEntity recipe) async {
    try {
      final box = HiveService.recipesBox;
      await box.put(recipe.id, recipe);
      return const Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void>> deleteRecipe(String id) async {
    try {
      final box = HiveService.recipesBox;
      await box.delete(id);
      return const Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}

