import 'package:hive/hive.dart';

part 'recipe_entity.g.dart';

@HiveType(typeId: 0)
class RecipeEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final List<int> fruitIds;

  RecipeEntity({
    required this.id,
    required this.name,
    this.description,
    required this.fruitIds,
  });
}

