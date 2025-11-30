import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/fruit.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/result.dart';
import '../providers/favorite_fruits_provider.dart';

class FruitDetailsScreen extends ConsumerStatefulWidget {
  final int fruitId;

  const FruitDetailsScreen({
    super.key,
    required this.fruitId,
  });

  @override
  ConsumerState<FruitDetailsScreen> createState() =>
      _FruitDetailsScreenState();
}

class _FruitDetailsScreenState extends ConsumerState<FruitDetailsScreen> {
  Fruit? _fruit;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFruit();
  }

  Future<void> _loadFruit() async {
    try {
      final useCase = ref.read(getAllFruitsUseCaseProvider);
      final result = await useCase.call();

      switch (result) {
        case Success(data: final fruits):
          final fruit = fruits.firstWhere(
                (f) => f.id == widget.fruitId,
            orElse: () => throw Exception('Fruit not found'),
          );
          setState(() {
            _fruit = fruit;
            _isLoading = false;
          });
        case Failure(exception: final exception):
          setState(() {
            _error = exception.toString();
            _isLoading = false;
          });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleFavorite() {
    ref.read(favoriteFruitsProvider.notifier).toggleFavorite(widget.fruitId);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteState = ref.watch(favoriteFruitsProvider);
    final isFavorite = favoriteState.favoriteIds.contains(widget.fruitId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_fruit?.name ?? 'Фрукт'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
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
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFruit,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_fruit == null) {
      return const Center(child: Text('Фрукт не найден'));
    }

    final fruit = _fruit!;
    final nut = fruit.nutritions;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Семейство',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(fruit.family,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  Text('Порядок',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(fruit.order,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  Text('Род',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(fruit.genus,
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Питательные свойства',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  // калории только целое число
                  _buildNutritionRow(
                      'Калории', '${nut.calories.round()} ккал'),
                  const Divider(),
                  _buildNutritionRow(
                      'Жиры', '${nut.fat.toStringAsFixed(1)} г'),
                  const Divider(),
                  _buildNutritionRow(
                      'Сахар', '${nut.sugar.toStringAsFixed(1)} г'),
                  const Divider(),
                  _buildNutritionRow('Углеводы',
                      '${nut.carbohydrates.toStringAsFixed(1)} г'),
                  const Divider(),
                  _buildNutritionRow(
                      'Белки', '${nut.protein.toStringAsFixed(1)} г'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}