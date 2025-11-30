import 'package:json_annotation/json_annotation.dart';

part 'fruit.g.dart';

@JsonSerializable()
class Fruit {
  final String name;
  final int id;
  final String family;
  final String order;
  final String genus;
  final Nutritions nutritions;

  Fruit({
    required this.name,
    required this.id,
    required this.family,
    required this.order,
    required this.genus,
    required this.nutritions,
  });

  factory Fruit.fromJson(Map<String, dynamic> json) => _$FruitFromJson(json);
  Map<String, dynamic> toJson() => _$FruitToJson(this);
}

@JsonSerializable()
class Nutritions {
  final double calories;
  final double fat;
  final double sugar;
  final double carbohydrates;
  final double protein;

  Nutritions({
    required this.calories,
    required this.fat,
    required this.sugar,
    required this.carbohydrates,
    required this.protein,
  });

  factory Nutritions.fromJson(Map<String, dynamic> json) =>
      _$NutritionsFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionsToJson(this);
}

