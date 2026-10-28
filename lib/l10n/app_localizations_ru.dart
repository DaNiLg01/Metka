// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Учёт расходов';

  @override
  String get homeScreen => 'Расходы';

  @override
  String get statsScreen => 'Статистика';

  @override
  String get settingsScreen => 'Настройки';

  @override
  String get categoriesScreen => 'Категории';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get noExpenses => 'Нет расходов. Нажмите +, чтобы добавить.';

  @override
  String get nothingFound => 'Ничего не найдено';

  @override
  String get search => 'Поиск...';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get addExpense => 'Новый расход';

  @override
  String get editExpense => 'Редактировать расход';

  @override
  String get title => 'Название';

  @override
  String get description => 'Описание';

  @override
  String get amount => 'Сумма';

  @override
  String get date => 'Дата';

  @override
  String get category => 'Категория';

  @override
  String get exportCSV => 'Экспорт в CSV';

  @override
  String get theme => 'Тёмная тема';

  @override
  String get language => 'Язык';

  @override
  String get currency => 'Валюта';

  @override
  String get period => 'Период';

  @override
  String get week => 'Неделя';

  @override
  String get month => 'Месяц';

  @override
  String get custom => 'Произвольный';

  @override
  String get apply => 'Применить';

  @override
  String get reset => 'Сбросить';

  @override
  String get filters => 'Фильтры';

  @override
  String get from => 'С';

  @override
  String get to => 'По';

  @override
  String get totalForPeriod => 'Всего за период';

  @override
  String get byCategories => 'По категориям';

  @override
  String get byDays => 'По дням';

  @override
  String get unknown => 'Неизвестно';
}
