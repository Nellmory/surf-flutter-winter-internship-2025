import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipes_provider.dart';
import '../widgets/recipe_card.dart';
import 'create_recipe_screen.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  static const Color primaryBlue = Color(0xFF375FAD);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recipesProvider.notifier).loadRecipes();
    });
  }

  void _openCreateRecipe() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateRecipeScreen()));
    ref.read(recipesProvider.notifier).loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text('Мои рецепты', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: _buildBody(state),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateRecipe,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.add, size: 28),
        label: const Text('Новый рецепт', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(RecipesState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: primaryBlue));
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            const Text('Не удалось загрузить рецепты', style: TextStyle(fontSize: 16)),
            Text(state.error!, style: TextStyle(color: Colors.grey[600]), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(recipesProvider.notifier).loadRecipes(),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
              style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            ),
          ],
        ),
      );
    }

    final recipes = state.recipes ?? [];

    if (recipes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryBlue.withOpacity(0.1),
                ),
                child: Icon(Icons.menu_book_outlined, size: 100, color: primaryBlue.withOpacity(0.7)),
              ),
              const SizedBox(height: 32),
              const Text(
                'У вас пока нет рецептов',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Нажмите кнопку ниже и создайте свой первый шедевр',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: primaryBlue,
      onRefresh: () async => ref.read(recipesProvider.notifier).loadRecipes(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 120),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RecipeCard(
              recipe: recipe,
              onDelete: () => ref.read(recipesProvider.notifier).deleteRecipe(recipe.id),
            ),
          );
        },
      ),
    );
  }
}