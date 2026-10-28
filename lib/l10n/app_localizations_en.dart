// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Expense Tracker';

  @override
  String get homeScreen => 'Expenses';

  @override
  String get statsScreen => 'Statistics';

  @override
  String get settingsScreen => 'Settings';

  @override
  String get categoriesScreen => 'Categories';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get noExpenses => 'No expenses. Tap + to add.';

  @override
  String get nothingFound => 'Nothing found';

  @override
  String get search => 'Search...';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get addExpense => 'New Expense';

  @override
  String get editExpense => 'Edit Expense';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get category => 'Category';

  @override
  String get exportCSV => 'Export to CSV';

  @override
  String get theme => 'Dark theme';

  @override
  String get language => 'Language';

  @override
  String get currency => 'Currency';

  @override
  String get period => 'Period';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get custom => 'Custom';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get filters => 'Filters';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get totalForPeriod => 'Total for period';

  @override
  String get byCategories => 'By categories';

  @override
  String get byDays => 'By days';

  @override
  String get unknown => 'Unknown';
}
