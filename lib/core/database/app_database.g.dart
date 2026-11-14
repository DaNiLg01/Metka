// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DriftCategoriesTable extends DriftCategories
    with TableInfo<$DriftCategoriesTable, DriftCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconCodeMeta =
      const VerificationMeta('iconCode');
  @override
  late final GeneratedColumn<String> iconCode = GeneratedColumn<String>(
      'icon_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, iconCode, colorValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_categories';
  @override
  VerificationContext validateIntegrity(Insertable<DriftCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_code')) {
      context.handle(_iconCodeMeta,
          iconCode.isAcceptableOrUnknown(data['icon_code']!, _iconCodeMeta));
    } else if (isInserting) {
      context.missing(_iconCodeMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      iconCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_code'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
    );
  }

  @override
  $DriftCategoriesTable createAlias(String alias) {
    return $DriftCategoriesTable(attachedDatabase, alias);
  }
}

class DriftCategory extends DataClass implements Insertable<DriftCategory> {
  final int id;
  final String name;
  final String iconCode;
  final int colorValue;
  const DriftCategory(
      {required this.id,
      required this.name,
      required this.iconCode,
      required this.colorValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon_code'] = Variable<String>(iconCode);
    map['color_value'] = Variable<int>(colorValue);
    return map;
  }

  DriftCategoriesCompanion toCompanion(bool nullToAbsent) {
    return DriftCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      iconCode: Value(iconCode),
      colorValue: Value(colorValue),
    );
  }

  factory DriftCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconCode: serializer.fromJson<String>(json['iconCode']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'iconCode': serializer.toJson<String>(iconCode),
      'colorValue': serializer.toJson<int>(colorValue),
    };
  }

  DriftCategory copyWith(
          {int? id, String? name, String? iconCode, int? colorValue}) =>
      DriftCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        iconCode: iconCode ?? this.iconCode,
        colorValue: colorValue ?? this.colorValue,
      );
  DriftCategory copyWithCompanion(DriftCategoriesCompanion data) {
    return DriftCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconCode: data.iconCode.present ? data.iconCode.value : this.iconCode,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCode: $iconCode, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, iconCode, colorValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconCode == this.iconCode &&
          other.colorValue == this.colorValue);
}

class DriftCategoriesCompanion extends UpdateCompanion<DriftCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> iconCode;
  final Value<int> colorValue;
  const DriftCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconCode = const Value.absent(),
    this.colorValue = const Value.absent(),
  });
  DriftCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String iconCode,
    required int colorValue,
  })  : name = Value(name),
        iconCode = Value(iconCode),
        colorValue = Value(colorValue);
  static Insertable<DriftCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? iconCode,
    Expression<int>? colorValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconCode != null) 'icon_code': iconCode,
      if (colorValue != null) 'color_value': colorValue,
    });
  }

  DriftCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? iconCode,
      Value<int>? colorValue}) {
    return DriftCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCode: iconCode ?? this.iconCode,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconCode.present) {
      map['icon_code'] = Variable<String>(iconCode.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconCode: $iconCode, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }
}

class $DriftExpensesTable extends DriftExpenses
    with TableInfo<$DriftExpensesTable, DriftExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_categories (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, amount, categoryName, categoryId, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_expenses';
  @override
  VerificationContext validateIntegrity(Insertable<DriftExpense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftExpense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $DriftExpensesTable createAlias(String alias) {
    return $DriftExpensesTable(attachedDatabase, alias);
  }
}

class DriftExpense extends DataClass implements Insertable<DriftExpense> {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String? categoryName;
  final int? categoryId;
  final DateTime date;
  const DriftExpense(
      {required this.id,
      required this.title,
      required this.description,
      required this.amount,
      this.categoryName,
      this.categoryId,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  DriftExpensesCompanion toCompanion(bool nullToAbsent) {
    return DriftExpensesCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      amount: Value(amount),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      date: Value(date),
    );
  }

  factory DriftExpense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftExpense(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'categoryName': serializer.toJson<String?>(categoryName),
      'categoryId': serializer.toJson<int?>(categoryId),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  DriftExpense copyWith(
          {String? id,
          String? title,
          String? description,
          double? amount,
          Value<String?> categoryName = const Value.absent(),
          Value<int?> categoryId = const Value.absent(),
          DateTime? date}) =>
      DriftExpense(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        categoryName:
            categoryName.present ? categoryName.value : this.categoryName,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        date: date ?? this.date,
      );
  DriftExpense copyWithCompanion(DriftExpensesCompanion data) {
    return DriftExpense(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftExpense(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('categoryName: $categoryName, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, description, amount, categoryName, categoryId, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftExpense &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.categoryName == this.categoryName &&
          other.categoryId == this.categoryId &&
          other.date == this.date);
}

class DriftExpensesCompanion extends UpdateCompanion<DriftExpense> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<double> amount;
  final Value<String?> categoryName;
  final Value<int?> categoryId;
  final Value<DateTime> date;
  final Value<int> rowid;
  const DriftExpensesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DriftExpensesCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required double amount,
    this.categoryName = const Value.absent(),
    this.categoryId = const Value.absent(),
    required DateTime date,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        amount = Value(amount),
        date = Value(date);
  static Insertable<DriftExpense> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? categoryName,
    Expression<int>? categoryId,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (categoryName != null) 'category_name': categoryName,
      if (categoryId != null) 'category_id': categoryId,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DriftExpensesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<double>? amount,
      Value<String?>? categoryName,
      Value<int?>? categoryId,
      Value<DateTime>? date,
      Value<int>? rowid}) {
    return DriftExpensesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      categoryName: categoryName ?? this.categoryName,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftExpensesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('categoryName: $categoryName, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DriftCategoriesTable driftCategories =
      $DriftCategoriesTable(this);
  late final $DriftExpensesTable driftExpenses = $DriftExpensesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [driftCategories, driftExpenses];
}

typedef $$DriftCategoriesTableCreateCompanionBuilder = DriftCategoriesCompanion
    Function({
  Value<int> id,
  required String name,
  required String iconCode,
  required int colorValue,
});
typedef $$DriftCategoriesTableUpdateCompanionBuilder = DriftCategoriesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> iconCode,
  Value<int> colorValue,
});

final class $$DriftCategoriesTableReferences extends BaseReferences<
    _$AppDatabase, $DriftCategoriesTable, DriftCategory> {
  $$DriftCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DriftExpensesTable, List<DriftExpense>>
      _driftExpensesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftExpenses,
              aliasName: 'drift_categories__id__drift_expenses__category_id');

  $$DriftExpensesTableProcessedTableManager get driftExpensesRefs {
    final manager = $$DriftExpensesTableTableManager($_db, $_db.driftExpenses)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftExpensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DriftCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $DriftCategoriesTable> {
  $$DriftCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconCode => $composableBuilder(
      column: $table.iconCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  Expression<bool> driftExpensesRefs(
      Expression<bool> Function($$DriftExpensesTableFilterComposer f) f) {
    final $$DriftExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftExpenses,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftExpensesTableFilterComposer(
              $db: $db,
              $table: $db.driftExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DriftCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DriftCategoriesTable> {
  $$DriftCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconCode => $composableBuilder(
      column: $table.iconCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));
}

class $$DriftCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriftCategoriesTable> {
  $$DriftCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconCode =>
      $composableBuilder(column: $table.iconCode, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  Expression<T> driftExpensesRefs<T extends Object>(
      Expression<T> Function($$DriftExpensesTableAnnotationComposer a) f) {
    final $$DriftExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftExpenses,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.driftExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DriftCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DriftCategoriesTable,
    DriftCategory,
    $$DriftCategoriesTableFilterComposer,
    $$DriftCategoriesTableOrderingComposer,
    $$DriftCategoriesTableAnnotationComposer,
    $$DriftCategoriesTableCreateCompanionBuilder,
    $$DriftCategoriesTableUpdateCompanionBuilder,
    (DriftCategory, $$DriftCategoriesTableReferences),
    DriftCategory,
    PrefetchHooks Function({bool driftExpensesRefs})> {
  $$DriftCategoriesTableTableManager(
      _$AppDatabase db, $DriftCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> iconCode = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
          }) =>
              DriftCategoriesCompanion(
            id: id,
            name: name,
            iconCode: iconCode,
            colorValue: colorValue,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String iconCode,
            required int colorValue,
          }) =>
              DriftCategoriesCompanion.insert(
            id: id,
            name: name,
            iconCode: iconCode,
            colorValue: colorValue,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({driftExpensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (driftExpensesRefs) db.driftExpenses
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (driftExpensesRefs)
                    await $_getPrefetchedData<DriftCategory,
                            $DriftCategoriesTable, DriftExpense>(
                        currentTable: table,
                        referencedTable: $$DriftCategoriesTableReferences
                            ._driftExpensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftCategoriesTableReferences(db, table, p0)
                                .driftExpensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DriftCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DriftCategoriesTable,
    DriftCategory,
    $$DriftCategoriesTableFilterComposer,
    $$DriftCategoriesTableOrderingComposer,
    $$DriftCategoriesTableAnnotationComposer,
    $$DriftCategoriesTableCreateCompanionBuilder,
    $$DriftCategoriesTableUpdateCompanionBuilder,
    (DriftCategory, $$DriftCategoriesTableReferences),
    DriftCategory,
    PrefetchHooks Function({bool driftExpensesRefs})>;
typedef $$DriftExpensesTableCreateCompanionBuilder = DriftExpensesCompanion
    Function({
  required String id,
  required String title,
  Value<String> description,
  required double amount,
  Value<String?> categoryName,
  Value<int?> categoryId,
  required DateTime date,
  Value<int> rowid,
});
typedef $$DriftExpensesTableUpdateCompanionBuilder = DriftExpensesCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<double> amount,
  Value<String?> categoryName,
  Value<int?> categoryId,
  Value<DateTime> date,
  Value<int> rowid,
});

final class $$DriftExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $DriftExpensesTable, DriftExpense> {
  $$DriftExpensesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DriftCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.driftCategories
          .createAlias('drift_expenses__category_id__drift_categories__id');

  $$DriftCategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager =
        $$DriftCategoriesTableTableManager($_db, $_db.driftCategories)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $DriftExpensesTable> {
  $$DriftExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  $$DriftCategoriesTableFilterComposer get categoryId {
    final $$DriftCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.driftCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.driftCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $DriftExpensesTable> {
  $$DriftExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  $$DriftCategoriesTableOrderingComposer get categoryId {
    final $$DriftCategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.driftCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftCategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.driftCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriftExpensesTable> {
  $$DriftExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$DriftCategoriesTableAnnotationComposer get categoryId {
    final $$DriftCategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.driftCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftCategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.driftCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DriftExpensesTable,
    DriftExpense,
    $$DriftExpensesTableFilterComposer,
    $$DriftExpensesTableOrderingComposer,
    $$DriftExpensesTableAnnotationComposer,
    $$DriftExpensesTableCreateCompanionBuilder,
    $$DriftExpensesTableUpdateCompanionBuilder,
    (DriftExpense, $$DriftExpensesTableReferences),
    DriftExpense,
    PrefetchHooks Function({bool categoryId})> {
  $$DriftExpensesTableTableManager(_$AppDatabase db, $DriftExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> categoryName = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DriftExpensesCompanion(
            id: id,
            title: title,
            description: description,
            amount: amount,
            categoryName: categoryName,
            categoryId: categoryId,
            date: date,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String> description = const Value.absent(),
            required double amount,
            Value<String?> categoryName = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            required DateTime date,
            Value<int> rowid = const Value.absent(),
          }) =>
              DriftExpensesCompanion.insert(
            id: id,
            title: title,
            description: description,
            amount: amount,
            categoryName: categoryName,
            categoryId: categoryId,
            date: date,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftExpensesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$DriftExpensesTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$DriftExpensesTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DriftExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DriftExpensesTable,
    DriftExpense,
    $$DriftExpensesTableFilterComposer,
    $$DriftExpensesTableOrderingComposer,
    $$DriftExpensesTableAnnotationComposer,
    $$DriftExpensesTableCreateCompanionBuilder,
    $$DriftExpensesTableUpdateCompanionBuilder,
    (DriftExpense, $$DriftExpensesTableReferences),
    DriftExpense,
    PrefetchHooks Function({bool categoryId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DriftCategoriesTableTableManager get driftCategories =>
      $$DriftCategoriesTableTableManager(_db, _db.driftCategories);
  $$DriftExpensesTableTableManager get driftExpenses =>
      $$DriftExpensesTableTableManager(_db, _db.driftExpenses);
}
