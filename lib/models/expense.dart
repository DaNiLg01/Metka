// ✅ ЭТА СТРОКА ОБЯЗАТЕЛЬНА! Она подключает иконки и цвета
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum ExpenseCategory {
  food('Еда', 'restaurant', 0xFF4A90E2),
  transport('Транспорт', 'directions_car', 0xFF50C878),
  groceries('Продукты', 'shopping_basket', 0xFF9B59B6),
  entertainment('Развлечения', 'theaters', 0xFFE74C3C),
  health('Здоровье', 'favorite', 0xFF1ABC9C),
  other('Другое', 'more_horiz', 0xFF95A5A6);

  final String name;
  final String iconName;
  final int colorValue;

  const ExpenseCategory(this.name, this.iconName, this.colorValue);

  IconData get icon {
    return _iconMap[iconName] ?? Icons.category;
  }

  static const Map<String, IconData> _iconMap = {
    'restaurant': Icons.restaurant,
    'directions_car': Icons.directions_car,
    'shopping_basket': Icons.shopping_basket,
    'theaters': Icons.theaters,
    'favorite': Icons.favorite,
    'more_horiz': Icons.more_horiz,
  };
}

class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  factory Expense.create({
    required String title,
    required String description,
    required double amount,
    required ExpenseCategory category,
  }) {
    return Expense(
      id: const Uuid().v4(),
      title: title,
      description: description,
      amount: amount,
      category: category,
      date: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'amount': amount,
    'category': category.index,
    'date': date.toIso8601String(),
  };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    amount: (json['amount'] as num).toDouble(),
    category: ExpenseCategory.values[json['category']],
    date: DateTime.parse(json['date']),
  );
}