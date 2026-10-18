import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';
import '../widgets/summary_card.dart';
import '../widgets/expense_item.dart';
import 'add_expense_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await StorageService.loadExpenses();
    setState(() => expenses = data);
  }

  Future<void> _saveData() async {
    await StorageService.saveExpenses(expenses);
  }

  double get totalExpenses =>
      expenses.fold(0, (sum, item) => sum + item.amount);

  Map<String, List<Expense>> get groupedExpenses {
    final Map<String, List<Expense>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var expense in expenses) {
      final d = DateTime(expense.date.year, expense.date.month, expense.date.day);
      String key;
      if (d == today) key = 'Сегодня';
      else if (d == yesterday) key = 'Вчера';
      else key = '${d.day}.${d.month}.${d.year}';

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(expense);
    }
    return grouped;
  }

  void _addExpense(Expense expense) {
    setState(() {
      expenses.insert(0, expense);
    });
    _saveData();
  }

  void _deleteExpense(String id) {
    setState(() {
      expenses.removeWhere((e) => e.id == id);
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF121218);
    final subtitleColor = isDark ? const Color(0xFF8B8B9E) : const Color(0xFF666666);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Расходы',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    onThemeChanged: widget.onThemeChanged,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: expenses.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: subtitleColor),
            const SizedBox(height: 16),
            Text(
              'Нет расходов. Нажмите +, чтобы добавить.',
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
            final dayTotal =
            entry.value.fold(0.0, (s, e) => s + e.amount);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key,
                        style: TextStyle(fontSize: 16, color: subtitleColor)),
                    Text('${dayTotal.toStringAsFixed(0)} ₽',
                        style: TextStyle(fontSize: 16, color: subtitleColor)),
                  ],
                ),
                const SizedBox(height: 12),
                ...entry.value.map((e) => ExpenseItem(
                  expense: e,
                  onDelete: () => _deleteExpense(e.id),
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