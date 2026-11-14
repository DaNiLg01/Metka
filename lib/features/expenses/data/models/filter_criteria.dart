class FilterCriteria {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<int> categoryIds; // ✅ БЫЛО: List<ExpenseCategory>
  final double? minAmount;
  final double? maxAmount;

  const FilterCriteria({
    this.startDate,
    this.endDate,
    this.categoryIds = const [], // ✅ Пустой список ID по умолчанию
    this.minAmount,
    this.maxAmount,
  });

  FilterCriteria copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<int>? categoryIds,
    double? minAmount,
    double? maxAmount,
  }) {
    return FilterCriteria(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryIds: categoryIds ?? this.categoryIds,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }

  bool get isEmpty =>
      startDate == null &&
          endDate == null &&
          categoryIds.isEmpty &&
          minAmount == null &&
          maxAmount == null;
}