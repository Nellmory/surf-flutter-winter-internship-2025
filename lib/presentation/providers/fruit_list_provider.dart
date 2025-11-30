import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/result.dart';
import '../../domain/models/fruit.dart';
import '../../domain/usecases/get_all_fruits_usecase.dart';
import '../../core/providers/providers.dart';

class FruitListState {
  final List<Fruit>? fruits;
  final List<Fruit>? filteredFruits;
  final bool isLoading;
  final String? error;
  final String? sortBy;
  final bool sortAscending;
  final List<NutritionFilter>? activeFilters;

  FruitListState({
    this.fruits,
    this.filteredFruits,
    this.isLoading = false,
    this.error,
    this.sortBy,
    this.sortAscending = true,
    this.activeFilters,
  });

  List<Fruit> get displayFruits => filteredFruits ?? fruits ?? [];

  FruitListState copyWith({
    List<Fruit>? fruits,
    List<Fruit>? filteredFruits,
    bool? isLoading,
    String? error,
    String? sortBy,
    bool? sortAscending,
    List<NutritionFilter>? activeFilters,
  }) {
    return FruitListState(
      fruits: fruits ?? this.fruits,
      filteredFruits: filteredFruits,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}

class NutritionFilter {
  final String name;
  final double? minCalories;
  final double? maxCalories;
  final double? minCarbohydrates;
  final double? maxCarbohydrates;
  final double? minSugar;
  final double? maxSugar;
  final double? minFat;
  final double? maxFat;
  final double? minProtein;
  final double? maxProtein;

  NutritionFilter({
    required this.name,
    this.minCalories,
    this.maxCalories,
    this.minCarbohydrates,
    this.maxCarbohydrates,
    this.minSugar,
    this.maxSugar,
    this.minFat,
    this.maxFat,
    this.minProtein,
    this.maxProtein,
  });

  bool matches(Fruit fruit) {
    final nut = fruit.nutritions;
    
    if (minCalories != null && nut.calories < minCalories!) return false;
    if (maxCalories != null && nut.calories > maxCalories!) return false;
    if (minCarbohydrates != null && nut.carbohydrates < minCarbohydrates!) return false;
    if (maxCarbohydrates != null && nut.carbohydrates > maxCarbohydrates!) return false;
    if (minSugar != null && nut.sugar < minSugar!) return false;
    if (maxSugar != null && nut.sugar > maxSugar!) return false;
    if (minFat != null && nut.fat < minFat!) return false;
    if (maxFat != null && nut.fat > maxFat!) return false;
    if (minProtein != null && nut.protein < minProtein!) return false;
    if (maxProtein != null && nut.protein > maxProtein!) return false;
    
    return true;
  }
}

class FruitListNotifier extends StateNotifier<FruitListState> {
  final GetAllFruitsUseCase getAllFruitsUseCase;

  FruitListNotifier({
    required this.getAllFruitsUseCase,
  }) : super(FruitListState());

  Future<void> loadFruits() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await getAllFruitsUseCase.call();
      
      switch (result) {
        case Success(data: final fruits):
          state = state.copyWith(
            fruits: fruits,
            filteredFruits: null,
            isLoading: false,
          );
          _applyFiltersAndSort();
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

  void applySort(String? sortBy, bool ascending) {
    state = state.copyWith(
      sortBy: sortBy,
      sortAscending: ascending,
    );
    _applyFiltersAndSort();
  }

  void applyFilters(List<NutritionFilter> filters) {
    state = state.copyWith(activeFilters: filters);
    _applyFiltersAndSort();
  }

  void clearFilters() {
    state = state.copyWith(
      activeFilters: null,
      filteredFruits: null,
      sortBy: null,
      sortAscending: true,
    );
  }

  void _applyFiltersAndSort() {
    var fruits = state.fruits ?? [];

    if (state.activeFilters != null && state.activeFilters!.isNotEmpty) {
      fruits = fruits.where((fruit) {
        return state.activeFilters!.every((filter) => filter.matches(fruit));
      }).toList();
    }

    if (state.sortBy != null) {
      fruits = List.from(fruits);
      switch (state.sortBy) {
        case 'name':
          fruits.sort((a, b) => state.sortAscending
              ? a.name.compareTo(b.name)
              : b.name.compareTo(a.name));
          break;
        case 'calories':
          fruits.sort((a, b) => state.sortAscending
              ? a.nutritions.calories.compareTo(b.nutritions.calories)
              : b.nutritions.calories.compareTo(a.nutritions.calories));
          break;
      }
    }
    
    state = state.copyWith(filteredFruits: fruits);
  }
}

final fruitListProvider =
    StateNotifierProvider<FruitListNotifier, FruitListState>((ref) {
  return FruitListNotifier(
    getAllFruitsUseCase: ref.watch(getAllFruitsUseCaseProvider),
  );
});

