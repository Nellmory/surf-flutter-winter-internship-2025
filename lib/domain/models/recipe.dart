import 'package:json_annotation/json_annotation.dart';
import 'fruit.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  final String id;
  final String name;
  final String? description;
  final List<int> fruitIds;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<Fruit>? fruits;

  Recipe({
    required this.id,
    required this.name,
    this.description,
    required this.fruitIds,
    this.fruits,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  Recipe copyWith({
    String? id,
    String? name,
    String? description,
    List<int>? fruitIds,
    List<Fruit>? fruits,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      fruitIds: fruitIds ?? this.fruitIds,
      fruits: fruits ?? this.fruits,
    );
  }

  Nutritions getTotalNutritions() {
    if (fruits == null || fruits!.isEmpty) {
      return Nutritions(
        calories: 0,
        fat: 0,
        sugar: 0,
        carbohydrates: 0,
        protein: 0,
      );
    }

    return Nutritions(
      calories: fruits!.fold(0.0, (sum, fruit) => sum + fruit.nutritions.calories),
      fat: fruits!.fold(0.0, (sum, fruit) => sum + fruit.nutritions.fat),
      sugar: fruits!.fold(0.0, (sum, fruit) => sum + fruit.nutritions.sugar),
      carbohydrates: fruits!.fold(0.0, (sum, fruit) => sum + fruit.nutritions.carbohydrates),
      protein: fruits!.fold(0.0, (sum, fruit) => sum + fruit.nutritions.protein),
    );
  }
}

