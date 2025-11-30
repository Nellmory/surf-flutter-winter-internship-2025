import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/api_service.dart';
import '../../data/remote/remote_data_source.dart';
import '../../data/local/local_data_source.dart';
import '../../data/repositories/fruit_repository_impl.dart';
import '../../domain/usecases/get_all_fruits_usecase.dart';
import '../../domain/usecases/favorite_fruits_usecase.dart';
import '../../domain/usecases/recipes_usecase.dart';

// API Service
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Data Sources
final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSource(ref.watch(apiServiceProvider));
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource();
});

// Repository
final fruitRepositoryProvider = Provider<FruitRepositoryImpl>((ref) {
  return FruitRepositoryImpl(
    remoteDataSource: ref.watch(remoteDataSourceProvider),
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

// Use Cases - Fruits
final getAllFruitsUseCaseProvider = Provider<GetAllFruitsUseCase>((ref) {
  return GetAllFruitsUseCase(ref.watch(fruitRepositoryProvider));
});

// Use Cases - Favorites
final getFavoriteFruitIdsUseCaseProvider = Provider<GetFavoriteFruitIdsUseCase>((ref) {
  return GetFavoriteFruitIdsUseCase(ref.watch(fruitRepositoryProvider));
});

final isFavoriteUseCaseProvider = Provider<IsFavoriteUseCase>((ref) {
  return IsFavoriteUseCase(ref.watch(fruitRepositoryProvider));
});

final addToFavoritesUseCaseProvider = Provider<AddToFavoritesUseCase>((ref) {
  return AddToFavoritesUseCase(ref.watch(fruitRepositoryProvider));
});

final removeFromFavoritesUseCaseProvider = Provider<RemoveFromFavoritesUseCase>((ref) {
  return RemoveFromFavoritesUseCase(ref.watch(fruitRepositoryProvider));
});

// Use Cases - Recipes
final getAllRecipesUseCaseProvider = Provider<GetAllRecipesUseCase>((ref) {
  return GetAllRecipesUseCase(ref.watch(fruitRepositoryProvider));
});

final getRecipeByIdUseCaseProvider = Provider<GetRecipeByIdUseCase>((ref) {
  return GetRecipeByIdUseCase(ref.watch(fruitRepositoryProvider));
});

final saveRecipeUseCaseProvider = Provider<SaveRecipeUseCase>((ref) {
  return SaveRecipeUseCase(ref.watch(fruitRepositoryProvider));
});

final deleteRecipeUseCaseProvider = Provider<DeleteRecipeUseCase>((ref) {
  return DeleteRecipeUseCase(ref.watch(fruitRepositoryProvider));
});

