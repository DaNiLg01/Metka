import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Модель категории расхода
class Category {
  final String id;
  final String name;
  final String iconCode; // Код иконки (например, 'Icons.food_bank')
  final int colorValue; // Цвет в формате int

  static const Uuid _uuid = Uuid();

  Category({
    String? id,
    required this.name,
    required this.iconCode,
    required this.colorValue,
  }) : id = id ?? _uuid.v4();

  /// Получение IconData из строки
  IconData get iconData {
    // Маппинг популярных иконок
    final iconMap = {
      'restaurant': Icons.restaurant,
      'directions_car': Icons.directions_car,
      'shopping_bag': Icons.shopping_bag,
      'movie': Icons.movie,
      'favorite': Icons.favorite,
      'more_horiz': Icons.more_horiz,
      'home': Icons.home,
      'work': Icons.work,
      'school': Icons.school,
      'fitness_center': Icons.fitness_center,
    };
    return iconMap[iconCode] ?? Icons.category;
  }

  /// Получение цвета из int
  Color get color => Color(colorValue);

  /// Конвертация в Map для хранения
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCode': iconCode,
      'colorValue': colorValue,
    };
  }

  /// Создание из Map
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      iconCode: map['iconCode'],
      colorValue: map['colorValue'],
    );
  }

  /// Копирование с изменениями
  Category copyWith({
    String? id,
    String? name,
    String? iconCode,
    int? colorValue,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCode: iconCode ?? this.iconCode,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}