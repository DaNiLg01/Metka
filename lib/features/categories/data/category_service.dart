import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/exceptions/app_exception.dart';
import 'category.dart';

class CategoryService {
  static AppDatabase? _db;

  static void init(AppDatabase database) {
    _db = database;
  }

  static Future<List<Category>> loadCategories() async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      final driftCategories = await _db!.select(_db!.driftCategories).get();
      if (driftCategories.isEmpty) {
        await _initializeDefaultCategories();
        return loadCategories();
      }
      return driftCategories.map(_driftToCategory).toList();
    } catch (e) {
      throw DatabaseException('Не удалось загрузить категории: $e');
    }
  }

  // ✅ ИСПРАВЛЕНО TC-07: проверка на дубликат имени
  static Future<void> addCategory(Category category) async {
    if (_db == null) throw DatabaseException('База данных не инициализирована');
    try {
      final existing = await (_db!.select(_db!.driftCategories)
        ..where((tbl) => tbl.name.equals(category.name)))
          .getSingleOrNull();

      if (existing != null) {
        throw DatabaseException('Категория с таким названием уже существует');
      }

      await _db!.into(_db!.driftCategories).insert(_categoryToDriftInsert(category));
    } on DatabaseException {
      rethrow; // ✅ Пробрасываем нашу ошибку как есть
    } catch (e) {
      throw DatabaseException('Не удалось добавить категорию: $e');
    }
  }

  // ✅ ИСПРАВЛЕНО: при редактировании тоже проверяем уникальность имени
  static Future<void> updateCategory(Category category) async {
    if (_db == null) throw DatabaseException('База данных не инициализирована');
    try {
      final intId = int.tryParse(category.id) ?? 0;

      // ✅ ИСПРАВЛЕНО: используем isNotValue() для корректного Expression в Drift
      final existing = await (_db!.select(_db!.driftCategories)
        ..where((tbl) => tbl.name.equals(category.name) & tbl.id.isNotValue(intId)))
          .getSingleOrNull();

      if (existing != null) {
        throw DatabaseException('Категория с таким названием уже существует');
      }

      await (_db!.update(_db!.driftCategories)..where((tbl) => tbl.id.equals(intId)))
          .write(DriftCategoriesCompanion(
        name: Value(category.name),
        iconCode: Value(category.iconCode),
        colorValue: Value(category.colorValue),
      ));
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Не удалось обновить категорию: $e');
    }
  }

  static Future<void> deleteCategory(String id) async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      final intId = int.tryParse(id) ?? 0;
      await (_db!.delete(_db!.driftCategories)..where((tbl) => tbl.id.equals(intId))).go();
    } catch (e) {
      throw DatabaseException('Не удалось удалить категорию: $e');
    }
  }

  static Future<void> _initializeDefaultCategories() async {
    try {
      if (_db == null) throw DatabaseException('База данных не инициализирована');
      final defaults = [
        Category(name: 'Еда', iconCode: 'restaurant', colorValue: 0xFF3D5A80),
        Category(name: 'Транспорт', iconCode: 'directions_car', colorValue: 0xFF4CAF50),
        Category(name: 'Продукты', iconCode: 'shopping_bag', colorValue: 0xFF9C27B0),
        Category(name: 'Развлечения', iconCode: 'movie', colorValue: 0xFFFF5722),
        Category(name: 'Здоровье', iconCode: 'favorite', colorValue: 0xFF00BCD4),
        Category(name: 'Другое', iconCode: 'more_horiz', colorValue: 0xFF9E9E9E),
      ];
      for (final cat in defaults) {
        await _db!.into(_db!.driftCategories).insert(_categoryToDriftInsert(cat));
      }
    } catch (e) {
      throw DatabaseException('Не удалось инициализировать категории: $e');
    }
  }

  static Category _driftToCategory(DriftCategory data) {
    return Category(
      id: data.id.toString(),
      name: data.name,
      iconCode: data.iconCode,
      colorValue: data.colorValue,
    );
  }

  static DriftCategoriesCompanion _categoryToDriftInsert(Category category) {
    return DriftCategoriesCompanion.insert(
      name: category.name,
      iconCode: category.iconCode,
      colorValue: category.colorValue,
    );
  }

  // ✅ Метод для получения ID категории по имени (нужен для переноса расходов)
  static Future<int?> getCategoryIdByName(String name) async {
    try {
      if (_db == null) return null;
      final category = await (_db!.select(_db!.driftCategories)
        ..where((tbl) => tbl.name.equals(name)))
          .getSingleOrNull();
      return category?.id;
    } catch (e) {
      return null;
    }
  }
}