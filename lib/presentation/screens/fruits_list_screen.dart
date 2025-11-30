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
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text('Фрукты', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _openSortAndFilter,
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
                    _showSnackBar(context, message: 'Фильтры сброшены');
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
          _showSnackBar(context, message: 'Фильтры и сортировка сброшены');
        } else if (hasFilters) {
          _showSnackBar(context, message: 'Фильтры сброшены');
        } else if (hasSort) {
          _showSnackBar(context, message: 'Сортировка сброшена');
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

  void _showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF375FAD).withOpacity(0.75),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF375FAD).withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF375FAD).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}