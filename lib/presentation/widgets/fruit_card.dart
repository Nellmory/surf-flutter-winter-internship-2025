import 'package:flutter/material.dart';
import '../../domain/models/fruit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorite_fruits_provider.dart';

class FruitCard extends ConsumerWidget {
  final Fruit fruit;
  final VoidCallback onTap;
  final bool showFavoriteButton;
  final VoidCallback? onFavoriteToggle;

  const FruitCard({
    super.key,
    required this.fruit,
    required this.onTap,
    this.showFavoriteButton = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(favoriteFruitsProvider);
    final isFavorite = favoriteState.favoriteIds.contains(fruit.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fruit.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fruit.family,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (showFavoriteButton && onFavoriteToggle != null)
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: onFavoriteToggle,
                    )
                  else if (!showFavoriteButton)
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        ref.read(favoriteFruitsProvider.notifier).toggleFavorite(fruit.id);
                      },
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildNutritionChip(
                    context,
                    '${fruit.nutritions.calories.toStringAsFixed(0)} ккал',
                    Icons.local_fire_department,
                  ),
                  const SizedBox(width: 8),
                  _buildNutritionChip(
                    context,
                    '${fruit.nutritions.carbohydrates.toStringAsFixed(1)}г',
                    Icons.grain,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionChip(BuildContext context, String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

