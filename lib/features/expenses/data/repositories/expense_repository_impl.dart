import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../services/storage_service.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  @override
  Future<List<Expense>> getExpenses() {
    return StorageService.loadExpenses();
  }

  @override
  Future<void> addExpense(Expense expense) {
    return StorageService.addExpense(expense);
  }

  @override
  Future<void> updateExpense(Expense expense) {
    return StorageService.updateExpense(expense);
  }

  @override
  Future<void> deleteExpense(String id) {
    return StorageService.deleteExpense(id);
  }

  @override
  Future<void> reassignExpensesCategory(int oldCategoryId, int newCategoryId) {
    return StorageService.reassignExpensesCategory(oldCategoryId, newCategoryId);
  }

  @override
  Future<int> countExpensesByCategory(int categoryId) {
    return StorageService.countExpensesByCategory(categoryId);
  }
}