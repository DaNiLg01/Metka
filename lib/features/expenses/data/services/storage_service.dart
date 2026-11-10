import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../models/expense.dart';

class StorageService {
  static AppDatabase? _db;

  static void init(AppDatabase database) {
    _db = database;
  }

  static Future<List<Expense>> loadExpenses() async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      final driftExpenses = await _db!.select(_db!.driftExpenses).get();
      return driftExpenses.map(_driftToExpense).toList();
    } catch (e) {
      throw DatabaseException('Не удалось загрузить расходы: $e');
    }
  }

  static Future<void> saveExpenses(List<Expense> expenses) async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      await _db!.transaction(() async {
        await _db!.delete(_db!.driftExpenses).go();
        for (final expense in expenses) {
          await _db!.into(_db!.driftExpenses).insert(_expenseToDrift(expense));
        }
      });
    } catch (e) {
      throw DatabaseException('Не удалось сохранить расходы: $e');
    }
  }

  static Future<void> addExpense(Expense expense) async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      await _db!.into(_db!.driftExpenses).insert(_expenseToDrift(expense));
    } catch (e) {
      throw DatabaseException('Не удалось добавить расход: $e');
    }
  }

  static Future<void> updateExpense(Expense expense) async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      await (_db!.update(_db!.driftExpenses)..where((tbl) => tbl.id.equals(expense.id)))
          .write(_expenseToDrift(expense));
    } catch (e) {
      throw DatabaseException('Не удалось обновить расход: $e');
    }
  }

  // ✅ НОВЫЙ МЕТОД: Переносит все расходы из одной категории в другую
  static Future<void> reassignExpensesCategory(String oldCategoryName, String newCategoryName) async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      await (_db!.update(_db!.driftExpenses)..where((tbl) => tbl.categoryName.equals(oldCategoryName)))
          .write(DriftExpensesCompanion(categoryName: Value(newCategoryName)));
    } catch (e) {
      throw DatabaseException('Не удалось перенести расходы: $e');
    }
  }

  // ✅ НОВЫЙ МЕТОД: Считает количество расходов в категории
  static Future<int> countExpensesByCategory(String categoryName) async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      final expenses = await (_db!.select(_db!.driftExpenses)..where((tbl) => tbl.categoryName.equals(categoryName))).get();
      return expenses.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<void> deleteExpense(String id) async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      await (_db!.delete(_db!.driftExpenses)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      throw DatabaseException('Не удалось удалить расход: $e');
    }
  }

  static Expense _driftToExpense(DriftExpense data) {
    return Expense(
      id: data.id,
      title: data.title,
      description: data.description,
      amount: data.amount,
      category: ExpenseCategory.values.firstWhere(
            (e) => e.name == data.categoryName,
        orElse: () => ExpenseCategory.other,
      ),
      date: data.date,
    );
  }

  static DriftExpensesCompanion _expenseToDrift(Expense expense) {
    return DriftExpensesCompanion.insert(
      id: expense.id,
      title: expense.title,
      description: Value(expense.description),
      amount: expense.amount,
      categoryName: expense.category.name,
      date: expense.date,
    );
  }
}