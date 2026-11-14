import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/exceptions/app_exception.dart';
// ✅ ИМПОРТИРУЕМ DOMAIN ENTITY ВМЕСТО DATA MODEL
import '../../domain/entities/expense.dart';

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

  static Future<void> reassignExpensesCategory(int oldCategoryId, int newCategoryId) async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      await (_db!.update(_db!.driftExpenses)..where((tbl) => tbl.categoryId.equals(oldCategoryId)))
          .write(DriftExpensesCompanion(categoryId: Value(newCategoryId)));
    } catch (e) {
      throw DatabaseException('Не удалось перенести расходы: $e');
    }
  }

  static Future<int> countExpensesByCategory(int categoryId) async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      final expenses = await (_db!.select(_db!.driftExpenses)..where((tbl) => tbl.categoryId.equals(categoryId))).get();
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

  // ✅ Маппинг: Drift -> Domain Entity
  static Expense _driftToExpense(DriftExpense data) {
    return Expense(
      id: data.id,
      title: data.title,
      description: data.description,
      amount: data.amount,
      categoryId: data.categoryId ?? 0,
      date: data.date,
    );
  }

  // ✅ Маппинг: Domain Entity -> Drift
  static DriftExpensesCompanion _expenseToDrift(Expense expense) {
    return DriftExpensesCompanion.insert(
      id: expense.id,
      title: expense.title,
      description: Value(expense.description),
      amount: expense.amount,
      categoryId: Value(expense.categoryId),
      date: expense.date,
      categoryName: const Value(''), // Заглушка для старой БД
    );
  }
}