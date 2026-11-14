import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Future<void> reassignExpensesCategory(int oldCategoryId, int newCategoryId);
  Future<int> countExpensesByCategory(int categoryId);
}