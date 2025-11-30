import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fruit_list_provider.dart';
import '../widgets/fruit_card.dart';
import 'fruit_details_screen.dart';
import 'sort_and_filter_screen.dart';

class FruitsListScreen extends ConsumerStatefulWidget {
  const FruitsListScreen({super.key});

  @override
  ConsumerState<FruitsListScreen> createState() => _FruitsListScreenState();
}

class _FruitsListScreenState extends ConsumerState<FruitsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fruitListProvider.notifier).loadFruits();
    });
  }

  void _openSortAndFilter() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SortAndFilterScreen(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final sortBy = result['sortBy'] as String?;
      final sortAscending = result['sortAscending'] as bool? ?? true;
      final filters = (result['filters'] as List?)?.cast<NutritionFilter>();

      if (sortBy != null) {
        ref.read(fruitListProvider.notifier).applySort(sortBy, sortAscending);
      }

      if (filters != null && filters.isNotEmpty) {
        ref.read(fruitListProvider.notifier).applyFilters(filters);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fruitListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Фрукты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _openSortAndFilter,
            tooltip: 'Сортировка и фильтры',
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(FruitListState state) {
    if (state.isLoading && state.displayFruits.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.displayFruits.isEmpty) {
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
                ref.read(fruitListProvider.notifier).loadFruits();
              },
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    final fruits = state.displayFruits;

    if (fruits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Фрукты не найдены',
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (state.activeFilters != null && state.activeFilters!.isNotEmpty)
              ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    ref.invalidate(fruitListProvider);
                    await ref.read(fruitListProvider.notifier).loadFruits();
                    _showGreenSnackBar(context, message: 'Фильтры сброшены');
                  },
                  child: const Text('Сбросить фильтры'),
                ),
              ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final currentState = ref.read(fruitListProvider);
        final hasFilters =
        (currentState.activeFilters != null && currentState.activeFilters!.isNotEmpty);
        final hasSort = currentState.sortBy != null;

        ref.invalidate(fruitListProvider);
        await ref.read(fruitListProvider.notifier).loadFruits();

        if (hasFilters && hasSort) {
          _showGreenSnackBar(context, message: 'Фильтры и сортировка сброшены');
        } else if (hasFilters) {
          _showGreenSnackBar(context, message: 'Фильтры сброшены');
        } else if (hasSort) {
          _showGreenSnackBar(context, message: 'Сортировка сброшена');
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final fruit = fruits[index];
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
          );
        },
      ),
    );
  }

  void _showGreenSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[700]?.withOpacity(0.75),
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}