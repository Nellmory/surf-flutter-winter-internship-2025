import 'package:hive_flutter/hive_flutter.dart';
import 'recipe_entity.dart';

class HiveService {
  static const String favoriteFruitsBoxName = 'favorite_fruits';
  static const String recipesBoxName = 'recipes';
  
  static Box<int>? _favoriteFruitsBox;
  static Box<RecipeEntity>? _recipesBox;

  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(RecipeEntityAdapter());
    }
    _favoriteFruitsBox = await Hive.openBox<int>(favoriteFruitsBoxName);
    _recipesBox = await Hive.openBox<RecipeEntity>(recipesBoxName);
  }

  static Box<int> get favoriteFruitsBox {
    if (_favoriteFruitsBox == null) {
      throw Exception('Hive not initialized. Call HiveService.init() first.');
    }
    return _favoriteFruitsBox!;
  }

  static Box<RecipeEntity> get recipesBox {
    if (_recipesBox == null) {
      throw Exception('Hive not initialized. Call HiveService.init() first.');
    }
    return _recipesBox!;
  }
}

