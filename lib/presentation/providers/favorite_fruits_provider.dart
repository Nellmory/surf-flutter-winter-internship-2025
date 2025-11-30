import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/result.dart';
import '../../domain/models/fruit.dart';
import '../../domain/usecases/favorite_fruits_usecase.dart';
import '../../domain/usecases/get_all_fruits_usecase.dart';
import '../../core/providers/providers.dart';

class FavoriteFruitsState {
  final List<Fruit>? favoriteFruits;
  final Set<int> favoriteIds;
  final bool isLoading;
  final String? error;

  FavoriteFruitsState({
    this.favoriteFruits,
    this.favoriteIds = const {},
    this.isLoading = false,
    this.error,
  });

  FavoriteFruitsState copyWith({
    List<Fruit>? favoriteFruits,
    Set<int>? favoriteIds,
    bool? isLoading,
    String? error,
  }) {
    return FavoriteFruitsState(
      favoriteFruits: favoriteFruits ?? this.favoriteFruits,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FavoriteFruitsNotifier extends StateNotifier<FavoriteFruitsState> {
  final GetFavoriteFruitIdsUseCase getFavoriteFruitIdsUseCase;
  final GetAllFruitsUseCase getAllFruitsUseCase;
  final AddToFavoritesUseCase addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;

  FavoriteFruitsNotifier({
    required this.getFavoriteFruitIdsUseCase,
    required this.getAllFruitsUseCase,
    required this.addToFavoritesUseCase,
    required this.removeFromFavoritesUseCase,
  }) : super(FavoriteFruitsState());

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final favoriteIdsResult = await getFavoriteFruitIdsUseCase.call();
      
      switch (favoriteIdsResult) {
        case Success(data: final favoriteIds):
          if (favoriteIds.isEmpty) {
            state = state.copyWith(
              favoriteFruits: [],
              favoriteIds: favoriteIds.toSet(),
              isLoading: false,
            );
            return;
          }

          final allFruitsResult = await getAllFruitsUseCase.call();
          
          switch (allFruitsResult) {
            case Success(data: final allFruits):
              final favorites = allFruits
                  .where((fruit) => favoriteIds.contains(fruit.id))
                  .toList();
              
              state = state.copyWith(
                favoriteFruits: favorites,
                favoriteIds: favoriteIds.toSet(),
                isLoading: false,
              );
            case Failure(exception: final exception):
              state = state.copyWith(
                isLoading: false,
                error: 'Произошла ошибка: ${exception.toString()}',
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

  Future<void> toggleFavorite(int fruitId) async {
    final isFavorite = state.favoriteIds.contains(fruitId);
    
    try {
      if (isFavorite) {
        final result = await removeFromFavoritesUseCase.call(fruitId);
        switch (result) {
          case Success():
            final newIds = Set<int>.from(state.favoriteIds)..remove(fruitId);
            final newFruits = state.favoriteFruits
                ?.where((fruit) => fruit.id != fruitId)
                .toList();
            state = state.copyWith(
              favoriteIds: newIds,
              favoriteFruits: newFruits,
            );
          case Failure(exception: final exception):
            state = state.copyWith(error: exception.toString());
        }
      } else {
        final result = await addToFavoritesUseCase.call(fruitId);
        switch (result) {
          case Success():
            final newIds = Set<int>.from(state.favoriteIds)..add(fruitId);
            state = state.copyWith(favoriteIds: newIds);
            await loadFavorites();
          case Failure(exception: final exception):
            state = state.copyWith(error: exception.toString());
        }
      }
    } catch (e) {
      state = state.copyWith(error: 'Ошибка: $e');
    }
  }

  bool isFavorite(int fruitId) {
    return state.favoriteIds.contains(fruitId);
  }
}

final favoriteFruitsProvider =
    StateNotifierProvider<FavoriteFruitsNotifier, FavoriteFruitsState>((ref) {
  return FavoriteFruitsNotifier(
    getFavoriteFruitIdsUseCase: ref.watch(getFavoriteFruitIdsUseCaseProvider),
    getAllFruitsUseCase: ref.watch(getAllFruitsUseCaseProvider),
    addToFavoritesUseCase: ref.watch(addToFavoritesUseCaseProvider),
    removeFromFavoritesUseCase: ref.watch(removeFromFavoritesUseCaseProvider),
  );
});

