import '../models/expense.dart';

/// Критерии фильтрации расходов
class FilterCriteria {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<ExpenseCategory> categories;
  final double? minAmount;
  final double? maxAmount;

  const FilterCriteria({
    this.startDate,
    this.endDate,
    this.categories = const [],
    this.minAmount,
    this.maxAmount,
  });

  /// Проверка, есть ли активные фильтры
  bool get hasActiveFilters {
    return startDate != null ||
        endDate != null ||
        categories.isNotEmpty ||
        minAmount != null ||
        maxAmount != null;
  }

  /// Сброс всех фильтров
  FilterCriteria get cleared => const FilterCriteria();

  /// Копирование с изменениями
  FilterCriteria copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<ExpenseCategory>? categories,
    double? minAmount,
    double? maxAmount,
    bool clearCategories = false,
  }) {
    return FilterCriteria(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categories: clearCategories
          ? const []
          : (categories ?? this.categories),
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }
}