import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

@DataClassName('DriftCategory')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get iconCode => text()();
  IntColumn get colorValue => integer()();
}

@DataClassName('DriftExpense')
class Expenses extends Table {
  // ✅ TextColumn, чтобы сохранить совместимость с UUID (String id)
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get amount => real()();
  // ✅ Храним имя категории текстом (например, 'food'), чтобы не делать сложные JOIN-запросы
  TextColumn get categoryName => text()();
  DateTimeColumn get date => dateTime()();
}

@DriftDatabase(tables: [Categories, Expenses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'expenses.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}