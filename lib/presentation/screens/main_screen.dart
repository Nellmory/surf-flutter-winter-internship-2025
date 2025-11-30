import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fruits_list_screen.dart';
import 'favorites_screen.dart';
import 'recipes_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FruitsListScreen(),
    const FavoritesScreen(),
    const RecipesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.basketShopping, color: Colors.grey),
            selectedIcon: FaIcon(FontAwesomeIcons.basketShopping, color: Colors.orange),
            label: 'Фрукты',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.favorite, color: Colors.orange),
            label: 'Избранное',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.menu_book, color: Colors.orange),
            label: 'Рецепты',
          ),
        ],
      ),
    );
  }
}

