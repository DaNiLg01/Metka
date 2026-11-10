import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

// ===== ТАБЛИЦА РАСХОДОВ =====
class DriftExpenses extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get amount => real()();
  TextColumn get categoryName => text()();
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ===== ТАБЛИЦА КАТЕГОРИЙ =====
class DriftCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get iconCode => text()();
  IntColumn get colorValue => integer()();
}

// ===== БАЗА ДАННЫХ С МИГРАЦИЕЙ =====
@DriftDatabase(tables: [DriftExpenses, DriftCategories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // ✅ Увеличили версию схемы с 1 на 2
  @override
  int get schemaVersion => 2;

  // ✅ Добавляем стратегию миграции
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      // При первом создании — создаём все таблицы
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // ✅ При обновлении с версии 1 на 2: удаляем старые таблицы и создаём новые
      if (from < 2) {
        await m.deleteTable('expenses');
        await m.deleteTable('categories');
        await m.createAll();
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'expenses.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}