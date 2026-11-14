class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final int categoryId;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.categoryId,
    required this.date,
  });

  factory Expense.create({
    required String title,
    required String description,
    required double amount,
    required int categoryId,
  }) {
    return Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      amount: amount,
      categoryId: categoryId,
      date: DateTime.now(),
    );
  }

  Expense copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    int? categoryId,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
    );
  }
}