import 'package:flutter/material.dart';
import '../../domain/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onDelete;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final totalNutritions = recipe.getTotalNutritions();
    final fruitNames = recipe.fruits
            ?.map((f) => f.name)
            .join(', ') ??
        'Фрукты загружаются...';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Удалить рецепт?'),
                        content: Text('Вы уверены, что хотите удалить рецепт "${recipe.name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete();
                            },
                            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            if (recipe.description != null && recipe.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                recipe.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Состав: $fruitNames',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Питательные свойства:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNutritionItem(
                        context,
                        'Калории',
                        '${totalNutritions.calories.toStringAsFixed(0)}',
                        'ккал',
                      ),
                      _buildNutritionItem(
                        context,
                        'Углеводы',
                        '${totalNutritions.carbohydrates.toStringAsFixed(1)}',
                        'г',
                      ),
                      _buildNutritionItem(
                        context,
                        'Белки',
                        '${totalNutritions.protein.toStringAsFixed(1)}',
                        'г',
                      ),
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

  Widget _buildNutritionItem(
    BuildContext context,
    String label,
    String value,
    String unit,
  ) {
    return Column(
      children: [
        Text(
          '$value $unit',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}

