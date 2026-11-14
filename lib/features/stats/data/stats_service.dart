import 'package:intl/intl.dart';
import '../../expenses/domain/entities/expense.dart'; // ✅ ИМПОРТ ИЗ DOMAIN
import '../../expenses/data/services/storage_service.dart';
import '../../categories/data/category.dart';
import '../../categories/data/category_service.dart';

class CategoryStats {
  final String categoryName;
  final String iconCode;
  final int colorValue;
  final double totalAmount;
  final int count;
  final double percentage;

  CategoryStats({
    required this.categoryName,
    required this.iconCode,
    required this.colorValue,
    required this.totalAmount,
    required this.count,
    required this.percentage,
  });
}

class DailyStats {
  final DateTime date;
  final double totalAmount;
  final int count;

  DailyStats({required this.date, required this.totalAmount, required this.count});
}

class StatsService {
  static Future<List<CategoryStats>> getCategoryStats(List<Expense> expenses, DateTime? start, DateTime? end) async {
    final categories = await CategoryService.loadCategories();

    final filtered = expenses.where((e) {
      if (start != null && e.date.isBefore(start)) return false;
      if (end != null && e.date.isAfter(end.add(const Duration(days: 1)))) return false;
      return true;
    }).toList();

    final double totalSum = filtered.fold(0.0, (sum, e) => sum + e.amount);
    final Map<int, CategoryStats> statsMap = {};

    for (final expense in filtered) {
      final cat = categories.firstWhere(
            (c) => c.id == expense.categoryId.toString(),
        orElse: () => Category(id: expense.categoryId.toString(), name: 'Неизвестно', iconCode: 'more_horiz', colorValue: 0xFF9E9E9E),
      );

      if (statsMap.containsKey(expense.categoryId)) {
        final current = statsMap[expense.categoryId]!;
        statsMap[expense.categoryId] = CategoryStats(
          categoryName: current.categoryName,
          iconCode: current.iconCode,
          colorValue: current.colorValue,
          totalAmount: current.totalAmount + expense.amount,
          count: current.count + 1,
          percentage: totalSum > 0 ? ((current.totalAmount + expense.amount) / totalSum) * 100 : 0,
        );
      } else {
        statsMap[expense.categoryId] = CategoryStats(
          categoryName: cat.name,
          iconCode: cat.iconCode,
          colorValue: cat.colorValue,
          totalAmount: expense.amount,
          count: 1,
          percentage: totalSum > 0 ? (expense.amount / totalSum) * 100 : 0,
        );
      }
    }

    return statsMap.values.toList()..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
  }

  static Future<List<DailyStats>> getDailyStats(List<Expense> expenses, DateTime? start, DateTime? end) async {
    final filtered = expenses.where((e) {
      if (start != null && e.date.isBefore(start)) return false;
      if (end != null && e.date.isAfter(end.add(const Duration(days: 1)))) return false;
      return true;
    }).toList();

    final Map<String, DailyStats> dailyMap = {};

    for (final expense in filtered) {
      final dateStr = DateFormat('yyyy-MM-dd').format(expense.date);
      final date = expense.date;

      if (dailyMap.containsKey(dateStr)) {
        final current = dailyMap[dateStr]!;
        dailyMap[dateStr] = DailyStats(
          date: date,
          totalAmount: current.totalAmount + expense.amount,
          count: current.count + 1,
        );
      } else {
        dailyMap[dateStr] = DailyStats(
          date: date,
          totalAmount: expense.amount,
          count: 1,
        );
      }
    }

    return dailyMap.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }
}