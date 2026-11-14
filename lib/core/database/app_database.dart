import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

// ===== ТАБЛИЦА КАТЕГОРИЙ =====
class DriftCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get iconCode => text()();
  IntColumn get colorValue => integer()();
}

// ===== ТАБЛИЦА РАСХОДОВ =====
class DriftExpenses extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get amount => real()();

  // ✅ Возвращаем старое поле, чтобы Drift знал о его существовании в БД.
  // Делаем nullable, чтобы избежать конфликтов при миграции.
  TextColumn get categoryName => text().nullable()();

  // ✅ Новое поле с внешним ключом (Foreign Key)
  IntColumn get categoryId => integer().nullable().references(DriftCategories, #id)();

  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ===== БАЗА ДАННЫХ =====
@DriftDatabase(tables: [DriftCategories, DriftExpenses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 3) {
        await m.addColumn(driftExpenses, driftExpenses.categoryId);
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