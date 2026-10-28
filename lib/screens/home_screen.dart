import 'package:flutter/material.dart';
import '../services/app_strings.dart';
import '../models/expense.dart';
import '../models/filter_criteria.dart';
import '../services/storage_service.dart';
import '../widgets/summary_card.dart';
import '../widgets/expense_item.dart';
import 'add_expense_screen.dart';
import 'filters_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];
  List<Expense> filteredExpenses = [];
  FilterCriteria _filterCriteria = const FilterCriteria();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await StorageService.loadExpenses();
    setState(() {
      expenses = data;
      _applyFilters();
    });
  }

  Future<void> _saveData() async {
    await StorageService.saveExpenses(expenses);
  }

  void _applyFilters() {
    var result = expenses;
    if (_searchQuery.isNotEmpty) {
      result = result.where((e) {
        final query = _searchQuery.toLowerCase();
        return e.title.toLowerCase().contains(query) ||
            e.description.toLowerCase().contains(query) ||
            e.category.name.toLowerCase().contains(query);
      }).toList();
    }

    if (_filterCriteria.hasActiveFilters) {
      result = result.where((e) {
        if (_filterCriteria.startDate != null && e.date.isBefore(_filterCriteria.startDate!)) return false;
        if (_filterCriteria.endDate != null && e.date.isAfter(_filterCriteria.endDate!.add(const Duration(days: 1)))) return false;
        if (_filterCriteria.categories.isNotEmpty && !_filterCriteria.categories.contains(e.category)) return false;
        if (_filterCriteria.minAmount != null && e.amount < _filterCriteria.minAmount!) return false;
        if (_filterCriteria.maxAmount != null && e.amount > _filterCriteria.maxAmount!) return false;
        return true;
      }).toList();
    }
    setState(() { filteredExpenses = result; });
  }

  Future<void> _openFilters() async {
    final result = await showDialog<FilterCriteria>(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          child: FiltersScreen(currentCriteria: _filterCriteria),
        ),
      ),
    );
    if (result != null) {
      setState(() { _filterCriteria = result; });
      _applyFilters();
    }
  }

  double get totalExpenses => filteredExpenses.fold(0, (sum, item) => sum + item.amount);

  Map<String, List<Expense>> get groupedExpenses {
    final Map<String, List<Expense>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var expense in filteredExpenses) {
      final d = DateTime(expense.date.year, expense.date.month, expense.date.day);
      String key;
      if (d == today) key = AppStrings.tr('today');
      else if (d == yesterday) key = AppStrings.tr('yesterday');
      else key = '${d.day}.${d.month}.${d.year}';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(expense);
    }
    return grouped;
  }

  void _addExpense(Expense expense) {
    setState(() { expenses.insert(0, expense); });
    _saveData();
    _applyFilters();
  }

  void _deleteExpense(String id) {
    setState(() { expenses.removeWhere((e) => e.id == id); });
    _saveData();
    _applyFilters();
  }

  Future<void> _editExpense(Expense expense) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => AddExpenseScreen(expense: expense)),
    );

    if (result is Expense) {
      final index = expenses.indexWhere((e) => e.id == result.id);
      if (index != -1) {
        setState(() { expenses[index] = result; });
        await _saveData();
        _applyFilters();
      }
    } else if (result == 'DELETE') {
      _deleteExpense(expense.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDark ? const Color(0xFF8B8B9E) : const Color(0xFF666666);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            hintText: AppStrings.tr('search'),
            hintStyle: const TextStyle(color: Color(0xFF8B8B9E)),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() { _searchQuery = value; });
            _applyFilters();
          },
        )
            : Text(
          AppStrings.tr('homeScreen'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _applyFilters();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: _filterCriteria.hasActiveFilters ? const Color(0xFF3D5A80) : null),
            onPressed: _openFilters,
          ),
        ],
      ),
      body: filteredExpenses.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: subtitleColor),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty || _filterCriteria.hasActiveFilters
                  ? AppStrings.tr('nothingFound')
                  : AppStrings.tr('noExpenses'),
              style: TextStyle(color: subtitleColor, fontSize: 16),
            ),
          ],
        ),
      )
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SummaryCard(total: totalExpenses),
          const SizedBox(height: 24),
          ...groupedExpenses.entries.map((entry) {
            final dayTotal = entry.value.fold(0.0, (s, e) => s + e.amount);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: TextStyle(fontSize: 16, color: subtitleColor)),
                    Text('${dayTotal.toStringAsFixed(0)} ₽', style: TextStyle(fontSize: 16, color: subtitleColor)),
                  ],
                ),
                const SizedBox(height: 12),
                ...entry.value.map((e) => GestureDetector(
                  onTap: () => _editExpense(e),
                  child: ExpenseItem(expense: e, onDelete: () => _deleteExpense(e.id)),
                )),
                const SizedBox(height: 24),
              ],
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Expense>(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
          if (result != null) _addExpense(result);
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}