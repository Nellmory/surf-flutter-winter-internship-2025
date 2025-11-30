import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fruit_list_provider.dart';

class SortAndFilterScreen extends ConsumerStatefulWidget {
  const SortAndFilterScreen({super.key});

  @override
  ConsumerState<SortAndFilterScreen> createState() =>
      _SortAndFilterScreenState();
}

class _SortAndFilterScreenState extends ConsumerState<SortAndFilterScreen> {
  String? _selectedSort;
  bool _sortAscending = true;
  final Set<String> _selectedFilters = {};

  final List<NutritionFilter> _predefinedFilters = [
    NutritionFilter(
      name: 'Завтрак',
      minCalories: 40,
      maxCalories: 80,
      minCarbohydrates: 10,
      maxSugar: 12,
      maxFat: 0.5,
    ),
    NutritionFilter(
      name: 'Тренировка',
      minCalories: 50,
      maxCalories: 100,
      minCarbohydrates: 12,
      maxFat: 0.3,
    ),
    NutritionFilter(
      name: 'Сытость',
      minCalories: 50,
      maxCalories: 90,
      minCarbohydrates: 10,
      maxCarbohydrates: 15,
      maxSugar: 10,
      minProtein: 0.5,
    ),
    NutritionFilter(
      name: 'Перекус',
      maxCalories: 50,
      maxSugar: 7,
      maxFat: 0.4,
    ),
    NutritionFilter(
      name: 'Диета',
      maxCalories: 40,
      maxSugar: 6,
      maxFat: 0.3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильтры'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Сортировка',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSortOption('name', 'По названию'),
            _buildSortOption('calories', 'По количеству калорий'),
            const SizedBox(height: 24),
            Text(
              'Фильтры',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ..._predefinedFilters.map((filter) => _buildFilterChip(filter)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Применить'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String value, String label) {
    final isSelected = _selectedSort == value;
    final isAscending = _sortAscending;

    return Card(
      child: RadioListTile<String>(
        title: Text(label),
        value: value,
        groupValue: _selectedSort,
        onChanged: (val) {
          setState(() {
            if (_selectedSort == val) {
              _sortAscending = !_sortAscending;
            } else {
              _selectedSort = val;
              _sortAscending = true;
            }
          });
        },
        secondary: isSelected
            ? Icon(isAscending ? Icons.arrow_upward : Icons.arrow_downward)
            : null,
      ),
    );
  }

  Widget _buildFilterChip(NutritionFilter filter) {
    final isSelected = _selectedFilters.contains(filter.name);

    return Card(
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: CheckboxListTile(
        title: Text(filter.name),
        subtitle: Text(_getFilterDescription(filter)),
        value: isSelected,
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selectedFilters.add(filter.name);
            } else {
              _selectedFilters.remove(filter.name);
            }
          });
        },
      ),
    );
  }

  String _getFilterDescription(NutritionFilter filter) {
    final parts = <String>[];
    if (filter.minCalories != null || filter.maxCalories != null) {
      final min = filter.minCalories ?? 0;
      final max = filter.maxCalories ?? double.infinity;
      parts.add('Калории: ${min.toStringAsFixed(0)}-${max == double.infinity ? '∞' : max.toStringAsFixed(0)} ккал');
    }
    if (filter.minCarbohydrates != null || filter.maxCarbohydrates != null) {
      final min = filter.minCarbohydrates ?? 0;
      final max = filter.maxCarbohydrates ?? double.infinity;
      parts.add('Углеводы: ${min.toStringAsFixed(0)}-${max == double.infinity ? '∞' : max.toStringAsFixed(0)} г');
    }
    if (filter.maxSugar != null) {
      parts.add('Сахар: ≤${filter.maxSugar!.toStringAsFixed(0)} г');
    }
    if (filter.maxFat != null) {
      parts.add('Жиры: ≤${filter.maxFat!.toStringAsFixed(1)} г');
    }
    if (filter.minProtein != null) {
      parts.add('Белки: ≥${filter.minProtein!.toStringAsFixed(1)} г');
    }
    return parts.join(', ');
  }

  void _applyFilters() {
    final selectedFilterObjects = _predefinedFilters
        .where((filter) => _selectedFilters.contains(filter.name))
        .toList();

    Navigator.pop(context, {
      'sortBy': _selectedSort,
      'sortAscending': _sortAscending,
      'filters': selectedFilterObjects,
    });
  }
}

