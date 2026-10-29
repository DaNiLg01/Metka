import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart'; // ✅ ДОБАВЛЕН ИМПОРТ AppColors
import '../../data/models/expense.dart';
import '../../data/models/filter_criteria.dart';
import '../../../export/presentation/export_screen.dart';
import '../../../filters/presentation/filters_screen.dart';
import '../widgets/expense_item.dart';
import '../widgets/summary_card.dart';
import 'add_expense_screen.dart';
import '../bloc/expense_cubit.dart';
import '../bloc/expense_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Предоставляем Cubit для этого экрана
    return BlocProvider(
      create: (context) => ExpenseCubit()..loadExpenses(),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => __HomeScreenViewState();
}

class __HomeScreenViewState extends State<_HomeScreenView> {
  String _searchQuery = '';
  FilterCriteria _filterCriteria = FilterCriteria();

  Future<void> _openAddExpense(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
    );

    if (result is Expense && mounted) {
      context.read<ExpenseCubit>().addExpense(result);
    }
  }

  Future<void> _editExpense(BuildContext context, Expense expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddExpenseScreen(expense: expense)),
    );

    if (result is Expense && mounted) {
      context.read<ExpenseCubit>().updateExpense(result);
    } else if (result == 'DELETE' && mounted) {
      context.read<ExpenseCubit>().deleteExpense(expense.id);
    }
  }

  Future<void> _deleteExpense(BuildContext context, Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.tr('deleteExpense')),
        content: Text(AppStrings.tr('cannotUndo')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppStrings.tr('cancel'))),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppStrings.tr('delete'))),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<ExpenseCubit>().deleteExpense(expense.id);
    }
  }

  Future<void> _openFilters(BuildContext context) async {
    final result = await Navigator.push<FilterCriteria>(
      context,
      MaterialPageRoute(
          builder: (context) => FiltersScreen(currentCriteria: _filterCriteria)),
    );

    if (result != null && mounted) {
      setState(() {
        _filterCriteria = result;
      });
    }
  }

  List<Expense> _getFilteredExpenses(List<Expense> expenses) {
    return expenses.where((e) {
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = e.title
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()) ||
            AppStrings.translateCategory(e.category.name)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
        if (!matchesSearch) return false;
      }

      if (_filterCriteria.startDate != null &&
          e.date.isBefore(_filterCriteria.startDate!)) return false;
      if (_filterCriteria.endDate != null &&
          e.date.isAfter(_filterCriteria.endDate!.add(const Duration(days: 1))))
        return false;
      if (_filterCriteria.categories.isNotEmpty &&
          !_filterCriteria.categories.contains(e.category)) return false;
      if (_filterCriteria.minAmount != null &&
          e.amount < _filterCriteria.minAmount!) return false;
      if (_filterCriteria.maxAmount != null &&
          e.amount > _filterCriteria.maxAmount!) return false;

      return true;
    }).toList();
  }

  Map<String, List<Expense>> _groupExpensesByDate(List<Expense> expenses) {
    final Map<String, List<Expense>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final expense in expenses) {
      final expenseDate =
      DateTime(expense.date.year, expense.date.month, expense.date.day);
      String key;
      if (expenseDate == today) {
        key = AppStrings.tr('today');
      } else if (expenseDate == yesterday) {
        key = AppStrings.tr('yesterday');
      } else {
        key = '${expenseDate.day}.${expenseDate.month}.${expenseDate.year}';
      }

      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(expense);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ ИСПОЛЬЗУЕМ AppColors ВМЕСТО ЖЕСТКО ЗАДАННЫХ ЦВЕТОВ
    final subtitleColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.tr('homeScreen'),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _ExpenseSearchDelegate(onSearch: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                }),
              );
            },
          ),
          IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _openFilters(context)),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ExportScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddExpense(context),
        child: const Icon(Icons.add),
      ),
      // ✅ СЛУШАЕМ СОСТОЯНИЕ ИЗ CUBIT
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExpenseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(state.message,
                      style: TextStyle(color: subtitleColor),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ExpenseCubit>().loadExpenses(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          } else if (state is ExpenseLoaded) {
            final filteredExpenses = _getFilteredExpenses(state.expenses);
            final groupedExpenses = _groupExpensesByDate(filteredExpenses);
            final totalAmount =
            filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);

            if (filteredExpenses.isEmpty) {
              return Center(
                child: Text(
                  _searchQuery.isNotEmpty
                      ? AppStrings.tr('nothingFound')
                      : AppStrings.tr('noExpenses'),
                  style: TextStyle(color: subtitleColor, fontSize: 16),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SummaryCard(total: totalAmount),
                const SizedBox(height: 16),
                ...groupedExpenses.entries.map((entry) {
                  final dayTotal =
                  entry.value.fold(0.0, (sum, e) => sum + e.amount);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key,
                                style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            Text(
                                '${dayTotal.toStringAsFixed(0)} ${AppStrings.getCurrencySymbol()}',
                                style: TextStyle(
                                    color: subtitleColor, fontSize: 14)),
                          ],
                        ),
                      ),
                      ...entry.value.map((expense) => GestureDetector(
                        onTap: () => _editExpense(context, expense),
                        child: ExpenseItem(
                          expense: expense,
                          onDelete: () => _deleteExpense(context, expense),
                        ),
                      )),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ExpenseSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;
  _ExpenseSearchDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch('');
        }),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onSearch(query);
    return const SizedBox.shrink();
  }
}