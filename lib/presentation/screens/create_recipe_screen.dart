import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/fruit.dart';
import '../../domain/usecases/get_all_fruits_usecase.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/result.dart';
import '../providers/favorite_fruits_provider.dart';
import '../providers/recipes_provider.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  ConsumerState<CreateRecipeScreen> createState() =>
      _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<int> _selectedFruitIds = {};
  List<Fruit>? _availableFruits;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAvailableFruits();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableFruits() async {
    try {
      final favoriteState = ref.read(favoriteFruitsProvider);
      if (favoriteState.favoriteFruits == null ||
          favoriteState.favoriteFruits!.isEmpty) {
        // Загружаем избранное, если еще не загружено
        await ref.read(favoriteFruitsProvider.notifier).loadFavorites();
      }

      final favoriteStateAfter = ref.read(favoriteFruitsProvider);
      final favoriteIds = favoriteStateAfter.favoriteIds;

      if (favoriteIds.isEmpty) {
        setState(() {
          _availableFruits = [];
          _isLoading = false;
        });
        return;
      }

      final useCase = ref.read(getAllFruitsUseCaseProvider);
      final result = await useCase.call();

      switch (result) {
        case Success(data: final allFruits):
          final favorites = allFruits
              .where((fruit) => favoriteIds.contains(fruit.id))
              .toList();
          setState(() {
            _availableFruits = favorites;
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

  void _toggleFruitSelection(int fruitId) {
    setState(() {
      if (_selectedFruitIds.contains(fruitId)) {
        _selectedFruitIds.remove(fruitId);
      } else {
        _selectedFruitIds.add(fruitId);
      }
    });
  }

  void _saveRecipe() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название рецепта')),
      );
      return;
    }

    if (_selectedFruitIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы один фрукт')),
      );
      return;
    }

    final recipe = Recipe(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      fruitIds: _selectedFruitIds.toList(),
    );

    ref.read(recipesProvider.notifier).saveRecipe(recipe);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание рецепта'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadAvailableFruits,
                child: const Text('Повторить'),
              ),
            ],
          ),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название рецепта',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание рецепта (опционально)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Text(
                'Выберите фрукты из избранного:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (_availableFruits == null ||
                  _availableFruits!.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Добавьте фрукты в избранное, чтобы использовать их в рецептах',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              else
                Column(
                  children: _availableFruits!.map((fruit) {
                    final isSelected =
                    _selectedFruitIds.contains(fruit.id);
                    return CheckboxListTile(
                      title: Text(fruit.name),
                      subtitle: Text(
                        '${fruit.nutritions.calories.toStringAsFixed(0)} ккал',
                      ),
                      value: isSelected,
                      onChanged: (_) =>
                          _toggleFruitSelection(fruit.id),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveRecipe,
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}