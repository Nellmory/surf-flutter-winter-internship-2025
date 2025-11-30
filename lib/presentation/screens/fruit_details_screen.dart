import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/fruit.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/result.dart';
import '../providers/favorite_fruits_provider.dart';

class FruitDetailsScreen extends ConsumerStatefulWidget {
  final int fruitId;
  const FruitDetailsScreen({super.key, required this.fruitId});

  @override
  ConsumerState<FruitDetailsScreen> createState() => _FruitDetailsScreenState();
}

class _FruitDetailsScreenState extends ConsumerState<FruitDetailsScreen> {
  Fruit? _fruit;
  bool _isLoading = true;
  String? _error;

  static const Color primaryBlue = Color(0xFF375FAD);
  static const Color favoriteRed = Color(0xFFD80050);

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
    final isFavorite = ref.watch(favoriteFruitsProvider).favoriteIds.contains(widget.fruitId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          _fruit?.name ?? 'Фрукт',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _toggleFavorite,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFavorite ? favoriteRed.withOpacity(0.1) : Colors.white.withOpacity(0.9),
                  boxShadow: isFavorite
                      ? [BoxShadow(color: favoriteRed.withOpacity(0.4), blurRadius: 6, spreadRadius: 1)]
                      : null,
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? favoriteRed : Colors.grey[600],
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryBlue))
          : _error != null
          ? _buildErrorState()
          : _buildContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadFruit,
            icon: const Icon(Icons.refresh),
            label: const Text('Повторить'),
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final fruit = _fruit!;
    final nut = fruit.nutritions;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoCard('Семейство', fruit.family),
          const SizedBox(height: 12),
          _buildInfoCard('Порядок', fruit.order),
          const SizedBox(height: 12),
          _buildInfoCard('Род', fruit.genus),

          const SizedBox(height: 32),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: primaryBlue.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(color: primaryBlue.withOpacity(0.15), blurRadius: 25),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Питательные свойства',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryBlue),
                ),
                const SizedBox(height: 24),

                _nutritionRow('Калории', '${nut.calories.round()} ккал', Icons.local_fire_department),
                const SizedBox(height: 20),
                _nutritionRow('Углеводы', '${nut.carbohydrates.toStringAsFixed(1)} г', Icons.grain),
                const SizedBox(height: 20),
                _nutritionRow('Белки', '${nut.protein.toStringAsFixed(1)} г', Icons.fitness_center),
                const SizedBox(height: 20),
                _nutritionRow('Жиры', '${nut.fat.toStringAsFixed(1)} г', Icons.opacity),
                const SizedBox(height: 20),
                _nutritionRow('Сахар', '${nut.sugar.toStringAsFixed(1)} г', Icons.cake),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _nutritionRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: primaryBlue, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 17)),
        ),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}