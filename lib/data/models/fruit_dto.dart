import 'package:json_annotation/json_annotation.dart';

part 'fruit_dto.g.dart';

@JsonSerializable()
class FruitDto {
  final String name;
  final int id;
  final String family;
  final String order;
  final String genus;
  final NutritionsDto nutritions;

  FruitDto({
    required this.name,
    required this.id,
    required this.family,
    required this.order,
    required this.genus,
    required this.nutritions,
  });

  factory FruitDto.fromJson(Map<String, dynamic> json) =>
      _$FruitDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FruitDtoToJson(this);
}

@JsonSerializable()
class NutritionsDto {
  final double calories;
  final double fat;
  final double sugar;
  final double carbohydrates;
  final double protein;

  NutritionsDto({
    required this.calories,
    required this.fat,
    required this.sugar,
    required this.carbohydrates,
    required this.protein,
  });

  factory NutritionsDto.fromJson(Map<String, dynamic> json) =>
      _$NutritionsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionsDtoToJson(this);
}

