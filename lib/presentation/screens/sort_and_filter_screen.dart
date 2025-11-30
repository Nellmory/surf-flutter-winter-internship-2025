import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fruit_list_provider.dart';

class SortAndFilterScreen extends ConsumerStatefulWidget {
  const SortAndFilterScreen({super.key});

  @override
  ConsumerState<SortAndFilterScreen> createState() => _SortAndFilterScreenState();
}

class _SortAndFilterScreenState extends ConsumerState<SortAndFilterScreen> {
  String? _selectedSort;
  bool _sortAscending = true;
  final Set<String> _selectedFilters = {};

  static const Color primaryBlue = Color(0xFF375FAD);

  final List<NutritionFilter> _predefinedFilters = [
    NutritionFilter(name: 'Завтрак', minCalories: 40, maxCalories: 80, minCarbohydrates: 10, maxSugar: 12, maxFat: 0.5),
    NutritionFilter(name: 'Тренировка', minCalories: 50, maxCalories: 100, minCarbohydrates: 12, maxFat: 0.3),
    NutritionFilter(name: 'Сытость', minCalories: 50, maxCalories: 90, minCarbohydrates: 10, maxCarbohydrates: 15, maxSugar: 10, minProtein: 0.5),
    NutritionFilter(name: 'Перекус', maxCalories: 50, maxSugar: 7, maxFat: 0.4),
    NutritionFilter(name: 'Диета', maxCalories: 40, maxSugar: 6, maxFat: 0.3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text('Фильтры и сортировка', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Сортировка'),
            const SizedBox(height: 12),
            ...['name', 'calories'].map((value) => _buildSortTile(value == 'name' ? 'По названию' : 'По калориям', value)),

            const SizedBox(height: 28),
            _buildSectionTitle('Быстрые фильтры'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _predefinedFilters.map((filter) => _buildFilterChip(filter)).toList(),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: primaryBlue.withOpacity(0.4),
                ),
                child: const Text('Применить', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
    );
  }

  Widget _buildSortTile(String label, String value) {
    final isSelected = _selectedSort == value;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? primaryBlue : Colors.grey[300]!, width: isSelected ? 2 : 1),
        boxShadow: [BoxShadow(color: primaryBlue.withOpacity(isSelected ? 0.2 : 0.08), blurRadius: 12)],
      ),
      child: RadioListTile<String>(
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
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        secondary: isSelected
            ? Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward, color: primaryBlue)
            : null,
        activeColor: primaryBlue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildFilterChip(NutritionFilter filter) {
    final isSelected = _selectedFilters.contains(filter.name);
    return FilterChip(
      label: Text(filter.name),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selected ? _selectedFilters.add(filter.name) : _selectedFilters.remove(filter.name);
        });
      },
      selectedColor: primaryBlue.withOpacity(0.15),
      checkmarkColor: primaryBlue,
      backgroundColor: Colors.grey[50],
      side: BorderSide(color: isSelected ? primaryBlue : Colors.grey[300]!, width: isSelected ? 2 : 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      labelStyle: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isSelected ? 4 : 0,
      shadowColor: primaryBlue.withOpacity(0.3),
    );
  }

  void _applyFilters() {
    final selectedFilters = _predefinedFilters.where((f) => _selectedFilters.contains(f.name)).toList();
    Navigator.pop(context, {
      'sortBy': _selectedSort,
      'sortAscending': _sortAscending,
      'filters': selectedFilters,
    });
  }
}