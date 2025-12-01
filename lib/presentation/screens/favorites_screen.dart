import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorite_fruits_provider.dart';
import '../widgets/fruit_card.dart';
import 'fruit_details_screen.dart';
import '../../core/constants/colors.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  static const Color primaryColor = AppColors.primaryColor;
  static const Color favoriteRed = AppColors.favoriteRed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoriteFruitsProvider.notifier).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favoriteFruitsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          'Избранное',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(FavoriteFruitsState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text('Не удалось загрузить избранное', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
            Text(state.error!, style: TextStyle(color: Colors.grey[600]), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(favoriteFruitsProvider.notifier).loadFavorites(),
              icon: const Icon(Icons.refresh),
              label: const Text('Попробовать снова'),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
            ),
          ],
        ),
      );
    }

    final favorites = state.favoriteFruits ?? [];

    if (favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: favoriteRed.withOpacity(0.1),
                ),
                child: Icon(Icons.favorite_border, size: 96, color: favoriteRed.withOpacity(0.6)),
              ),
              const SizedBox(height: 32),
              const Text(
                'Ваше избранное пока пусто',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Нажмите на сердечко на карточке фрукта,\nчтобы добавить его сюда',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: () async => ref.read(favoriteFruitsProvider.notifier).loadFavorites(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 100),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final fruit = favorites[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FruitCard(
              fruit: fruit,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FruitDetailsScreen(fruitId: fruit.id)),
              ),
              showFavoriteButton: true,
              onFavoriteToggle: () => ref.read(favoriteFruitsProvider.notifier).toggleFavorite(fruit.id),
            ),
          );
        },
      ),
    );
  }
}