import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../models/expense.dart';

class StorageService {
  static AppDatabase? _db;

  static void init(AppDatabase database) {
    _db = database;
  }

  /// Загружает все расходы из базы данных
  static Future<List<Expense>> loadExpenses() async {
    try {
      if (_db == null) {
        throw DatabaseException('База данных не инициализирована');
      }

      final driftExpenses = await _db!.select(_db!.expenses).get();
      return driftExpenses.map(_driftToExpense).toList();
    } catch (e) {
      throw DatabaseException('Не удалось загрузить расходы: $e');
    }
  }

  /// Сохраняет список расходов (используется для массовой перезаписи)
  static Future<void> saveExpenses(List<Expense> expenses) async {
    try {
      if (_db == null) {
        throw DatabaseException('База данных не инициализирована');
      }

      await _db!.transaction(() async {
        await _db!.delete(_db!.expenses).go();
        for (final expense in expenses) {
          await _db!.into(_db!.expenses).insert(_expenseToDrift(expense));
        }
      });
    } catch (e) {
      throw DatabaseException('Не удалось сохранить расходы: $e');
    }
  }

  /// Добавляет один расход
  static Future<void> addExpense(Expense expense) async {
    try {
      if (_db == null) {
        throw DatabaseException('База данных не инициализирована');
      }
      await _db!.into(_db!.expenses).insert(_expenseToDrift(expense));
    } catch (e) {
      throw DatabaseException('Не удалось добавить расход: $e');
    }
  }

  /// Обновляет существующий расход
  static Future<void> updateExpense(Expense expense) async {
    try {
      if (_db == null) {
        throw DatabaseException('База данных не инициализирована');
      }
      await _db!.update(_db!.expenses).replace(_expenseToDrift(expense));
    } catch (e) {
      throw DatabaseException('Не удалось обновить расход: $e');
    }
  }

  /// Удаляет расход по ID
  static Future<void> deleteExpense(String id) async {
    try {
      if (_db == null) {
        throw DatabaseException('База данных не инициализирована');
      }
      await (_db!.delete(_db!.expenses)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      throw DatabaseException('Не удалось удалить расход: $e');
    }
  }

  // ===== МАППИНГ (Преобразование типов) =====

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

  static ExpensesCompanion _expenseToDrift(Expense expense) {
    return ExpensesCompanion.insert(
      id: expense.id,
      title: expense.title,
      description: Value(expense.description),
      amount: expense.amount,
      categoryName: expense.category.name,
      date: expense.date,
    );
  }
}