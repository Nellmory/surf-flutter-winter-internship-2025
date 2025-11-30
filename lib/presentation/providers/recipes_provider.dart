import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/result.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/fruit.dart';
import '../../domain/usecases/recipes_usecase.dart';
import '../../domain/usecases/get_all_fruits_usecase.dart';
import '../../core/providers/providers.dart';

class RecipesState {
  final List<Recipe>? recipes;
  final bool isLoading;
  final String? error;

  RecipesState({
    this.recipes,
    this.isLoading = false,
    this.error,
  });

  RecipesState copyWith({
    List<Recipe>? recipes,
    bool? isLoading,
    String? error,
  }) {
    return RecipesState(
      recipes: recipes ?? this.recipes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RecipesNotifier extends StateNotifier<RecipesState> {
  final GetAllRecipesUseCase getAllRecipesUseCase;
  final GetRecipeByIdUseCase getRecipeByIdUseCase;
  final SaveRecipeUseCase saveRecipeUseCase;
  final DeleteRecipeUseCase deleteRecipeUseCase;
  final GetAllFruitsUseCase getAllFruitsUseCase;

  RecipesNotifier({
    required this.getAllRecipesUseCase,
    required this.getRecipeByIdUseCase,
    required this.saveRecipeUseCase,
    required this.deleteRecipeUseCase,
    required this.getAllFruitsUseCase,
  }) : super(RecipesState());

  Future<void> loadRecipes() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await getAllRecipesUseCase.call();
      
      switch (result) {
        case Success(data: final recipes):
          final allFruitsResult = await getAllFruitsUseCase.call();
          
          switch (allFruitsResult) {
            case Success(data: final allFruits):
              final recipesWithFruits = recipes.map((recipe) {
                final fruits = recipe.fruitIds
                    .map((id) => allFruits.firstWhere(
                          (fruit) => fruit.id == id,
                          orElse: () => throw Exception('Fruit not found: $id'),
                        ))
                    .toList();
                return recipe.copyWith(fruits: fruits);
              }).toList();
              
              state = state.copyWith(
                recipes: recipesWithFruits,
                isLoading: false,
              );
            case Failure(exception: final exception):
              state = state.copyWith(
                isLoading: false,
                error: 'Ошибка загрузки фруктов: ${exception.toString()}',
              );
          }
        case Failure(exception: final exception):
          state = state.copyWith(
            isLoading: false,
            error: 'Произошла ошибка: ${exception.toString()}',
          );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Произошла ошибка: $e',
      );
    }
  }

  Future<void> saveRecipe(Recipe recipe) async {
    try {
      final result = await saveRecipeUseCase.call(recipe);
      
      switch (result) {
        case Success():
          await loadRecipes();
        case Failure(exception: final exception):
          state = state.copyWith(error: exception.toString());
      }
    } catch (e) {
      state = state.copyWith(error: 'Ошибка сохранения: $e');
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      final result = await deleteRecipeUseCase.call(id);
      
      switch (result) {
        case Success():
          await loadRecipes();
        case Failure(exception: final exception):
          state = state.copyWith(error: exception.toString());
      }
    } catch (e) {
      state = state.copyWith(error: 'Ошибка удаления: $e');
    }
  }
}

final recipesProvider =
    StateNotifierProvider<RecipesNotifier, RecipesState>((ref) {
  return RecipesNotifier(
    getAllRecipesUseCase: ref.watch(getAllRecipesUseCaseProvider),
    getRecipeByIdUseCase: ref.watch(getRecipeByIdUseCaseProvider),
    saveRecipeUseCase: ref.watch(saveRecipeUseCaseProvider),
    deleteRecipeUseCase: ref.watch(deleteRecipeUseCaseProvider),
    getAllFruitsUseCase: ref.watch(getAllFruitsUseCaseProvider),
  );
});

