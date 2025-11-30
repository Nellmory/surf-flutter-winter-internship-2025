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

  static const Color primaryBlue = Color(0xFF375FAD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          height: 76,
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: primaryBlue.withOpacity(0.15),
          selectedIndex: _currentIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: [
            // Фрукты
            NavigationDestination(
              icon: const FaIcon(FontAwesomeIcons.basketShopping, size: 22),
              selectedIcon: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [primaryBlue, Color(0xFF5288F0)],
                ).createShader(bounds),
                child: const FaIcon(FontAwesomeIcons.basketShopping, size: 26),
              ),
              label: 'Фрукты',
            ),
            // Избранное
            NavigationDestination(
              icon: const Icon(Icons.favorite_outline, size: 26),
              selectedIcon: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFD80050), Color(0xFFF06292)],
                ).createShader(bounds),
                child: const Icon(Icons.favorite, size: 30),
              ),
              label: 'Избранное',
            ),
            // Рецепты
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined, size: 26),
              selectedIcon: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [primaryBlue, Color(0xFF5288F0)],
                ).createShader(bounds),
                child: const Icon(Icons.menu_book, size: 30),
              ),
              label: 'Рецепты',
            ),
          ],
        ),
      ),
    );
  }
}