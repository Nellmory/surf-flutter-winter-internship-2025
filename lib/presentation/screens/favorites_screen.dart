import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorite_fruits_provider.dart';
import '../widgets/fruit_card.dart';
import '../widgets/loading_item.dart';
import 'fruit_details_screen.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
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
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(FavoriteFruitsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(favoriteFruitsProvider.notifier).loadFavorites();
              },
              child: const Text('Перезагрузить'),
            ),
          ],
        ),
      );
    }

    final favorites = state.favoriteFruits ?? [];

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Вы пока ничего не добавили в избранное',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(favoriteFruitsProvider.notifier).loadFavorites();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final fruit = favorites[index];
          return FruitCard(
            fruit: fruit,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FruitDetailsScreen(fruitId: fruit.id),
                ),
              );
            },
            showFavoriteButton: true,
            onFavoriteToggle: () {
              ref.read(favoriteFruitsProvider.notifier).toggleFavorite(fruit.id);
            },
          );
        },
      ),
    );
  }
}

