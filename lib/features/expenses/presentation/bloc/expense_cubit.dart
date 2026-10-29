import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/expense.dart';
import '../../data/services/storage_service.dart';
import '../../../../core/exceptions/app_exception.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseInitial());

  /// Загрузка расходов
  Future<void> loadExpenses() async {
    emit(ExpenseLoading());
    try {
      final expenses = await StorageService.loadExpenses();
      emit(ExpenseLoaded(expenses));
    } on AppException catch (e) {
      emit(ExpenseError(e.message));
    } catch (e) {
      emit(const ExpenseError('Произошла неизвестная ошибка'));
    }
  }

  /// Добавление расхода
  Future<void> addExpense(Expense expense) async {
    try {
      await StorageService.addExpense(expense);
      // После добавления перезагружаем список
      await loadExpenses();
    } on AppException catch (e) {
      emit(ExpenseError(e.message));
    }
  }

  /// Обновление расхода
  Future<void> updateExpense(Expense expense) async {
    try {
      await StorageService.updateExpense(expense);
      await loadExpenses();
    } on AppException catch (e) {
      emit(ExpenseError(e.message));
    }
  }

  /// Удаление расхода
  Future<void> deleteExpense(String id) async {
    try {
      await StorageService.deleteExpense(id);
      await loadExpenses();
    } on AppException catch (e) {
      emit(ExpenseError(e.message));
    }
  }
}