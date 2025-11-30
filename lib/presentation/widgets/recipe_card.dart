// widgets/recipe_card.dart
import 'package:flutter/material.dart';
import '../../domain/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onDelete;

  const RecipeCard({super.key, required this.recipe, required this.onDelete});

  static const Color primaryBlue = Color(0xFF375FAD);
  static const Color favoriteRed = Color(0xFFD80050);

  @override
  Widget build(BuildContext context) {
    final total = recipe.getTotalNutritions();
    final fruitNames = recipe.fruits?.map((f) => f.name).join(', ') ?? 'Фрукты загружаются...';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryBlue.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(color: primaryBlue.withOpacity(0.12), blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    recipe.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black87),
                  ),
                ),
                IconButton(
                  onPressed: () => _showDeleteDialog(context),
                  icon: Icon(Icons.delete_outline, color: favoriteRed.withOpacity(0.8)),
                  splashRadius: 24,
                ),
              ],
            ),

            if (recipe.description?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(recipe.description!, style: TextStyle(color: Colors.grey[700], fontSize: 15)),
            ],

            const SizedBox(height: 16),
            Text('Состав: $fruitNames', style: TextStyle(color: Colors.grey[600], fontSize: 14)),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryBlue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Питательные свойства', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _nutritionItem('Калории', '${total.calories.toStringAsFixed(0)} ккал', Icons.local_fire_department),
                      _nutritionItem('Углеводы', '${total.carbohydrates.toStringAsFixed(1)} г', Icons.grain),
                      _nutritionItem('Белки', '${total.protein.toStringAsFixed(1)} г', Icons.fitness_center),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nutritionItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: primaryBlue),
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Удалить рецепт?'),
        content: Text('Рецепт "${recipe.name}" будет удалён навсегда.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Text('Удалить', style: TextStyle(color: favoriteRed)),
          ),
        ],
      ),
    );
  }
}