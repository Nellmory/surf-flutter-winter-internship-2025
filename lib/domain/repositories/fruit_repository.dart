import '../../core/utils/result.dart';
import '../models/fruit.dart';
import '../models/recipe.dart';

abstract class FruitRepository {
  Future<Result<List<Fruit>>> getAllFruits();
  
  // Избранное
  Future<Result<List<int>>> getFavoriteFruitIds();
  Future<Result<bool>> isFavorite(int fruitId);
  Future<Result<void>> addToFavorites(int fruitId);
  Future<Result<void>> removeFromFavorites(int fruitId);
  
  // Рецепты
  Future<Result<List<Recipe>>> getAllRecipes();
  Future<Result<Recipe?>> getRecipeById(String id);
  Future<Result<void>> saveRecipe(Recipe recipe);
  Future<Result<void>> deleteRecipe(String id);
}

