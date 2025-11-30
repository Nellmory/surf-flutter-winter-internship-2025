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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recipesProvider.notifier).loadRecipes();
    });
  }

  void _openCreateRecipe() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateRecipeScreen(),
      ),
    );
    ref.read(recipesProvider.notifier).loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепты'),
      ),
      body: _buildBody(state),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(RecipesState state) {
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
                ref.read(recipesProvider.notifier).loadRecipes();
              },
              child: const Text('Перезагрузить'),
            ),
          ],
        ),
      );
    }

    final recipes = state.recipes ?? [];

    if (recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Создайте свой первый рецепт',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(recipesProvider.notifier).loadRecipes();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCard(
            recipe: recipe,
            onDelete: () {
              ref.read(recipesProvider.notifier).deleteRecipe(recipe.id);
            },
          );
        },
      ),
    );
  }
}

