import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/exceptions/app_exception.dart';
import 'category.dart';

class CategoryService {
  static AppDatabase? _db;

  static void init(AppDatabase database) {
    _db = database;
  }

  /// Загружает все категории из базы данных
  static Future<List<Category>> loadCategories() async {
    try {
      if (_db == null) {
        throw DatabaseException('База данных не инициализирована');
      }

      final driftCategories = await _db!.select(_db!.categories).get();

      // Если база пустая, инициализируем стандартные категории
      if (driftCategories.isEmpty) {
        await _initializeDefaultCategories();
        return loadCategories(); // Рекурсивно загружаем уже созданные
      }

      return driftCategories.map(_driftToCategory).toList();
    } catch (e) {
      throw DatabaseException('Не удалось загрузить категории: $e');
    }
  }

  /// Добавляет новую категорию
  static Future<void> addCategory(Category category) async {
    try {
      if (_db == null) {
        throw DatabaseException('База данных не инициализирована');
      }
      await _db!.into(_db!.categories).insert(_categoryToDrift(category));
    } catch (e) {
      throw DatabaseException('Не удалось добавить категорию: $e');
    }
  }

  /// Обновляет существующую категорию
  static Future<void> updateCategory(Category category) async {
    try {
      if (_db == null) {
        throw DatabaseException('База данных не инициализирована');
      }
      await _db!.update(_db!.categories).replace(_categoryToDrift(category));
    } catch (e) {
      throw DatabaseException('Не удалось обновить категорию: $e');
    }
  }

  /// Удаляет категорию по ID
  static Future<void> deleteCategory(String id) async {
    try {
      if (_db == null) {
        throw DatabaseException('База данных не инициализирована');
      }
      final intId = int.tryParse(id) ?? 0;
      await (_db!.delete(_db!.categories)..where((tbl) => tbl.id.equals(intId))).go();
    } catch (e) {
      throw DatabaseException('Не удалось удалить категорию: $e');
    }
  }

  /// Инициализация стандартных категорий при первом запуске
  static Future<void> _initializeDefaultCategories() async {
    try {
      if (_db == null) {
        throw DatabaseException('База данных не инициализирована');
      }

      final defaults = [
        Category(name: 'Еда', iconCode: 'restaurant', colorValue: 0xFF3D5A80),
        Category(name: 'Транспорт', iconCode: 'directions_car', colorValue: 0xFF4CAF50),
        Category(name: 'Продукты', iconCode: 'shopping_bag', colorValue: 0xFF9C27B0),
        Category(name: 'Развлечения', iconCode: 'movie', colorValue: 0xFFFF5722),
        Category(name: 'Здоровье', iconCode: 'favorite', colorValue: 0xFF00BCD4),
        Category(name: 'Другое', iconCode: 'more_horiz', colorValue: 0xFF9E9E9E),
      ];

      for (final cat in defaults) {
        await _db!.into(_db!.categories).insert(_categoryToDrift(cat));
      }
    } catch (e) {
      throw DatabaseException('Не удалось инициализировать категории: $e');
    }
  }

  // ===== МАППИНГ =====

  static Category _driftToCategory(DriftCategory data) {
    return Category(
      id: data.id.toString(),
      name: data.name,
      iconCode: data.iconCode,
      colorValue: data.colorValue,
    );
  }

  static CategoriesCompanion _categoryToDrift(Category category) {
    return CategoriesCompanion.insert(
      name: category.name,
      iconCode: category.iconCode,
      colorValue: category.colorValue,
    );
  }
}