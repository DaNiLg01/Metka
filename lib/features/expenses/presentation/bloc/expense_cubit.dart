import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart'; // ✅ ДОБАВЛЕНО: для getIt
import '../../domain/entities/expense.dart'; // ✅ ИСПРАВЛЕНО: Domain Entity
import '../../domain/repositories/expense_repository.dart'; // ✅ ДОБАВЛЕНО: интерфейс репозитория
import '../../../../core/exceptions/app_exception.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseInitial());

  /// Загрузка расходов
  Future<void> loadExpenses() async {
    emit(ExpenseLoading());
    try {
      // ✅ ИСПОЛЬЗУЕМ REPOSITORY ЧЕРЕЗ GET_IT (вместо StorageService)
      final expenses = await getIt<ExpenseRepository>().getExpenses();
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
      await getIt<ExpenseRepository>().addExpense(expense);
      // После добавления перезагружаем список
      await loadExpenses();
    } on AppException catch (e) {
      emit(ExpenseError(e.message));
    }
  }

  /// Обновление расхода
  Future<void> updateExpense(Expense expense) async {
    try {
      await getIt<ExpenseRepository>().updateExpense(expense);
      await loadExpenses();
    } on AppException catch (e) {
      emit(ExpenseError(e.message));
    }
  }

  /// Удаление расхода
  Future<void> deleteExpense(String id) async {
    try {
      await getIt<ExpenseRepository>().deleteExpense(id);
      await loadExpenses();
    } on AppException catch (e) {
      emit(ExpenseError(e.message));
    }
  }
}