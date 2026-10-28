import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';

/// Сервис для работы с категориями (хранение в SharedPreferences)
class CategoryService {
  static const String _key = 'categories';

  /// Загрузка всех категорий
  static Future<List<Category>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);

    if (data == null) {
      // Возвращаем категории по умолчанию
      return _getDefaultCategories();
    }

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => Category.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  /// Сохранение всех категорий
  static Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
    categories.map((c) => c.toMap()).toList();
    await prefs.setString(_key, json.encode(jsonList));
  }

  /// Добавление категории
  static Future<void> addCategory(Category category) async {
    final categories = await loadCategories();
    categories.add(category);
    await saveCategories(categories);
  }

  /// Обновление категории
  static Future<void> updateCategory(Category category) async {
    final categories = await loadCategories();
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      categories[index] = category;
      await saveCategories(categories);
    }
  }

  /// Удаление категории
  static Future<void> deleteCategory(String id) async {
    final categories = await loadCategories();
    categories.removeWhere((c) => c.id == id);
    await saveCategories(categories);
  }

  /// Категории по умолчанию
  static List<Category> _getDefaultCategories() {
    return [
      Category(name: 'Еда', iconCode: 'restaurant', colorValue: 0xFF3D5A80),
      Category(name: 'Транспорт', iconCode: 'directions_car', colorValue: 0xFF4CAF50),
      Category(name: 'Продукты', iconCode: 'shopping_bag', colorValue: 0xFF9C27B0),
      Category(name: 'Развлечения', iconCode: 'movie', colorValue: 0xFFFF5722),
      Category(name: 'Здоровье', iconCode: 'favorite', colorValue: 0xFF00BCD4),
      Category(name: 'Другое', iconCode: 'more_horiz', colorValue: 0xFF9E9E9E),
    ];
  }
}