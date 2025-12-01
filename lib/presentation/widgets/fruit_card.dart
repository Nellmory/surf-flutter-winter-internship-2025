import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/fruit.dart';
import '../providers/favorite_fruits_provider.dart';
import '../../core/constants/colors.dart';

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
    final isFavorite = ref.watch(favoriteFruitsProvider).favoriteIds.contains(fruit.id);
    const Color primaryColor = AppColors.primaryColor;
    const Color favoriteRed = AppColors.favoriteRed;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white,
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            fruit.family,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: onFavoriteToggle ??
                              () => ref.read(favoriteFruitsProvider.notifier).toggleFavorite(fruit.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFavorite ? favoriteRed.withOpacity(0.1) : Colors.grey[50],
                          boxShadow: isFavorite
                              ? [
                            BoxShadow(
                              color: favoriteRed.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                              : null,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? favoriteRed : Colors.grey[500],
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.white, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            '${fruit.nutritions.calories.toStringAsFixed(0)} ккал',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.grain, color: Colors.grey[700], size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '${fruit.nutritions.carbohydrates.toStringAsFixed(1)}г',
                            style: TextStyle(color: Colors.grey[800], fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}