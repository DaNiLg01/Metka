import 'package:flutter/material.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/service_locator.dart'; // ✅ DI
import '../../domain/entities/expense.dart'; // ✅ Domain Entity
import '../../domain/repositories/expense_repository.dart'; // ✅ Domain Interface
import '../../data/models/filter_criteria.dart';
import '../../../categories/data/category.dart';
import '../../../categories/data/category_service.dart';
import '../widgets/expense_item.dart';
import 'add_expense_screen.dart';
import '../../../filters/presentation/filters_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];
  List<Category> _categories = [];
  FilterCriteria _filterCriteria = const FilterCriteria();
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // ✅ Используем Repository через getIt
      final expenses = await getIt<ExpenseRepository>().getExpenses();
      final categories = await CategoryService.loadCategories();
      setState(() {
        _expenses = expenses;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Данные загружены'), backgroundColor: Colors.green),
      );
    }
  }

  void _applyFilters(FilterCriteria criteria) {
    setState(() {
      _filterCriteria = criteria;
    });
  }

  List<Expense> get _filteredExpenses {
    return _expenses.where((e) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final cat = _categories.firstWhere(
              (c) => c.id == e.categoryId.toString(),
          orElse: () => Category(id: '0', name: 'Неизвестно', iconCode: 'more_horiz', colorValue: 0xFF9E9E9E),
        );

        if (!e.title.toLowerCase().contains(query) &&
            !e.description.toLowerCase().contains(query) &&
            !AppStrings.translateCategory(cat.name).toLowerCase().contains(query) &&
            !e.amount.toString().contains(query)) {
          return false;
        }
      }

      if (_filterCriteria.startDate != null && e.date.isBefore(_filterCriteria.startDate!)) return false;
      if (_filterCriteria.endDate != null && e.date.isAfter(_filterCriteria.endDate!.add(const Duration(days: 1)))) return false;
      if (_filterCriteria.categoryIds.isNotEmpty && !_filterCriteria.categoryIds.contains(e.categoryId)) return false;
      if (_filterCriteria.minAmount != null && e.amount < _filterCriteria.minAmount!) return false;
      if (_filterCriteria.maxAmount != null && e.amount > _filterCriteria.maxAmount!) return false;

      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _addExpense(Expense expense) async {
    // ✅ Используем Repository через getIt
    await getIt<ExpenseRepository>().addExpense(expense);
    _loadData();
  }

  Future<void> _updateExpense(Expense expense) async {
    // ✅ Используем Repository через getIt
    await getIt<ExpenseRepository>().updateExpense(expense);
    _loadData();
  }

  Future<void> _deleteExpense(String id) async {
    // ✅ Используем Repository через getIt
    await getIt<ExpenseRepository>().deleteExpense(id);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
        title: Text(
          AppStrings.tr('homeScreen'),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? AppColors.textLight : Colors.black87),
        ),
        iconTheme: IconThemeData(color: isDark ? AppColors.textLight : Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final result = await showDialog<FilterCriteria>(
                context: context,
                builder: (context) => FiltersScreen(currentCriteria: _filterCriteria),
              );
              if (result != null) _applyFilters(result);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.tr('search'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: _filteredExpenses.isEmpty
                ? Center(child: Text(AppStrings.tr('noExpenses'), style: TextStyle(color: colorScheme.onSurfaceVariant)))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredExpenses.length,
              itemBuilder: (context, index) {
                final expense = _filteredExpenses[index];
                final category = _categories.firstWhere(
                      (c) => c.id == expense.categoryId.toString(),
                  orElse: () => Category(id: '0', name: 'Неизвестно', iconCode: 'more_horiz', colorValue: 0xFF9E9E9E),
                );

                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push<Expense>(
                      context,
                      MaterialPageRoute(builder: (context) => AddExpenseScreen(expense: expense)),
                    );
                    if (result != null) {
                      if (result == 'DELETE' as dynamic) {
                        _deleteExpense(expense.id);
                      } else {
                        _updateExpense(result);
                      }
                    }
                  },
                  child: ExpenseItem(expense: expense, category: category),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Expense>(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
          if (result != null) _addExpense(result);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}