import '../models/expense.dart';
import '../models/category.dart';

/// Модель для данных круговой диаграммы
class CategoryStats {
  final String categoryName;
  final String iconCode;
  final int colorValue;
  final double totalAmount;
  final double percentage;

  CategoryStats({
    required this.categoryName,
    required this.iconCode,
    required this.colorValue,
    required this.totalAmount,
    required this.percentage,
  });
}

/// Модель для данных графика по времени
class DailyStats {
  final DateTime date;
  final double totalAmount;

  DailyStats({required this.date, required this.totalAmount});
}

/// Сервис для расчёта статистики
class StatsService {
  /// Получить статистику по категориям за период
  static List<CategoryStats> getCategoryStats(
      List<Expense> expenses,
      DateTime? startDate,
      DateTime? endDate,
      ) {
    // Фильтруем расходы по периоду
    final filtered = _filterByDate(expenses, startDate, endDate);

    // Группируем по категориям (используем enum ExpenseCategory)
    final Map<String, _CategoryData> categoryTotals = {};
    double grandTotal = 0;

    for (var expense in filtered) {
      final catKey = expense.category.name;
      if (!categoryTotals.containsKey(catKey)) {
        categoryTotals[catKey] = _CategoryData(
          name: expense.category.name,
          iconCode: expense.category.iconName,
          colorValue: expense.category.colorValue,
          total: 0,
        );
      }
      categoryTotals[catKey]!.total += expense.amount;
      grandTotal += expense.amount;
    }

    // Создаём список статистики
    return categoryTotals.values.map((data) {
      return CategoryStats(
        categoryName: data.name,
        iconCode: data.iconCode,
        colorValue: data.colorValue,
        totalAmount: data.total,
        percentage: grandTotal > 0 ? (data.total / grandTotal) * 100 : 0,
      );
    }).toList()
      ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
  }

  /// Получить статистику по дням
  static List<DailyStats> getDailyStats(
      List<Expense> expenses,
      DateTime? startDate,
      DateTime? endDate,
      ) {
    final filtered = _filterByDate(expenses, startDate, endDate);

    final Map<String, double> dailyTotals = {};

    for (var expense in filtered) {
      final dateKey =
          '${expense.date.year}-${expense.date.month}-${expense.date.day}';
      dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + expense.amount;
    }

    return dailyTotals.entries.map((entry) {
      final parts = entry.key.split('-');
      return DailyStats(
        date: DateTime(
            int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2])),
        totalAmount: entry.value,
      );
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Фильтрация по дате
  static List<Expense> _filterByDate(
      List<Expense> expenses,
      DateTime? startDate,
      DateTime? endDate,
      ) {
    if (startDate == null && endDate == null) return expenses;

    return expenses.where((e) {
      if (startDate != null && e.date.isBefore(startDate)) return false;
      if (endDate != null &&
          e.date.isAfter(endDate.add(const Duration(days: 1)))) {
        return false;
      }
      return true;
    }).toList();
  }
}

/// Вспомогательный класс для накопления данных
class _CategoryData {
  final String name;
  final String iconCode;
  final int colorValue;
  double total;

  _CategoryData({
    required this.name,
    required this.iconCode,
    required this.colorValue,
    required this.total,
  });
}