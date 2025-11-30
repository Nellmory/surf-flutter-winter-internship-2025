import '../models/fruit_dto.dart';
import '../../domain/models/fruit.dart';

class FruitMapper {
  static Fruit toDomain(FruitDto dto) {
    return Fruit(
      id: dto.id,
      name: dto.name,
      family: dto.family,
      order: dto.order,
      genus: dto.genus,
      nutritions: Nutritions(
        calories: dto.nutritions.calories,
        fat: dto.nutritions.fat,
        sugar: dto.nutritions.sugar,
        carbohydrates: dto.nutritions.carbohydrates,
        protein: dto.nutritions.protein,
      ),
    );
  }

  static List<Fruit> toDomainList(List<FruitDto> dtos) {
    return dtos.map((dto) => toDomain(dto)).toList();
  }
}

