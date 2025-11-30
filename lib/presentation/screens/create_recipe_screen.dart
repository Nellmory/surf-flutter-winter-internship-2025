import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/fruit.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/result.dart';
import '../providers/favorite_fruits_provider.dart';
import '../providers/recipes_provider.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  ConsumerState<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<int> _selectedFruitIds = {};
  List<Fruit>? _availableFruits;
  bool _isLoading = true;
  String? _error;

  static const Color primaryBlue = Color(0xFF375FAD);
  static const Color favoriteRed = Color(0xFFD80050);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAvailableFruits());
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
    setState(
      () => _selectedFruitIds.contains(fruitId)
          ? _selectedFruitIds.remove(fruitId)
          : _selectedFruitIds.add(fruitId),
    );
  }

  void _saveRecipe() {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Введите название рецепта');
      return;
    }
    if (_selectedFruitIds.isEmpty) {
      _showSnackBar('Выберите хотя бы один фрукт');
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Рецепт сохранён!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: favoriteRed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          'Новый рецепт',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: _saveRecipe,
            child: const Text(
              'Готово',
              style: TextStyle(
                color: primaryBlue,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryBlue))
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_dissatisfied,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ошибка загрузки',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _loadAvailableFruits,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Повторить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(_nameController, 'Название рецепта *', false),
                  const SizedBox(height: 20),
                  _buildTextField(
                    _descriptionController,
                    'Описание (необязательно)',
                    true,
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Фрукты из избранного',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),
                  if (_availableFruits!.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Нет избранных фруктов',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Text(
                            'Добавьте фрукты в избранное, чтобы использовать их в рецептах',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: _availableFruits!.map((fruit) {
                        final isSelected = _selectedFruitIds.contains(fruit.id);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? primaryBlue
                                  : primaryBlue.withOpacity(0.25),
                              width: isSelected ? 2.2 : 1.6,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryBlue.withOpacity(
                                  isSelected ? 0.25 : 0.12,
                                ),
                                blurRadius: isSelected ? 20 : 12,
                                spreadRadius: isSelected ? 4 : 1,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _toggleFruitSelection(fruit.id),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeOutCubic,
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? primaryBlue
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? primaryBlue
                                              : Colors.grey[400]!,
                                          width: 2.5,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 20,
                                            )
                                          : null,
                                    ),

                                    const SizedBox(width: 18),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fruit.name,
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w800,
                                              color: isSelected
                                                  ? primaryBlue
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${fruit.nutritions.calories.round()} ккал • ${fruit.family}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: isSelected
                                                  ? primaryBlue.withOpacity(0.8)
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? primaryBlue
                                            : primaryBlue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.local_fire_department,
                                            size: 18,
                                            color: isSelected
                                                ? Colors.white
                                                : primaryBlue,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${fruit.nutritions.calories.round()}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.white
                                                  : primaryBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 10,
                        shadowColor: primaryBlue.withOpacity(0.5),
                      ),
                      child: const Text(
                        'Сохранить рецепт',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    bool multiLine,
  ) {
    return TextField(
      controller: controller,
      maxLines: multiLine ? 4 : 1,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}
