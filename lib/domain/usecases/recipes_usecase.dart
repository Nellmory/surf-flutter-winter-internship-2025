import '../../core/utils/result.dart';
import '../../domain/models/recipe.dart';
import '../../domain/repositories/fruit_repository.dart';

class GetAllRecipesUseCase {
  final FruitRepository repository;

  GetAllRecipesUseCase(this.repository);

  Future<Result<List<Recipe>>> call() async {
    return await repository.getAllRecipes();
  }
}

class GetRecipeByIdUseCase {
  final FruitRepository repository;

  GetRecipeByIdUseCase(this.repository);

  Future<Result<Recipe?>> call(String id) async {
    return await repository.getRecipeById(id);
  }
}

class SaveRecipeUseCase {
  final FruitRepository repository;

  SaveRecipeUseCase(this.repository);

  Future<Result<void>> call(Recipe recipe) async {
    return await repository.saveRecipe(recipe);
  }
}

class DeleteRecipeUseCase {
  final FruitRepository repository;

  DeleteRecipeUseCase(this.repository);

  Future<Result<void>> call(String id) async {
    return await repository.deleteRecipe(id);
  }
}

