import '../../main.dart';

class AppStrings {
  static Map<String, Map<String, String>> translations = {
    'ru': {
      'appName': 'Учёт расходов',
      'homeScreen': 'Расходы',
      'statsScreen': 'Статистика',
      'settingsScreen': 'Настройки',
      'categoriesScreen': 'Категории',
      'today': 'Сегодня',
      'yesterday': 'Вчера',
      'noExpenses': 'Нет расходов. Нажмите +, чтобы добавить.',
      'noCategories': 'Нет категорий. Нажмите +, чтобы добавить.',
      'nothingFound': 'Ничего не найдено',
      'search': 'Поиск...',
      'save': 'Сохранить',
      'cancel': 'Отмена',
      'delete': 'Удалить',
      'addExpense': 'Новый расход',
      'editExpense': 'Редактировать расход',
      'title': 'Название',
      'description': 'Описание',
      'amount': 'Сумма',
      'date': 'Дата',
      'category': 'Категория',
      'exportCSV': 'Экспорт в CSV',
      'theme': 'Тёмная тема',
      'language': 'Язык',
      'currency': 'Валюта',
      'navExpenses': 'Расходы',
      'navCategories': 'Категории',
      'navStats': 'Статистика',
      'navSettings': 'Настройки',
      'currencySymbol': '₽',
      'currencyName': 'Рубль',
      'period': 'Период',
      'week': 'Неделя',
      'month': 'Месяц',
      'custom': 'Произвольный',
      'apply': 'Применить',
      'reset': 'Сбросить',
      'filters': 'Фильтры',
      'from': 'С',
      'to': 'По',
      'totalForPeriod': 'Всего за период',
      'byCategories': 'По категориям',
      'byDays': 'По дням',
      'unknown': 'Неизвестно',
      'enterTitle': 'Введите название',
      'enterAmount': 'Введите сумму',
      'minAmount': 'Сумма от',
      'maxAmount': 'Сумма до',
      'enterPositiveNumber': 'Введите положительное число',
      'deleteExpense': 'Удалить расход?',
      'cannotUndo': 'Это действие нельзя отменить.',
      'deleteCategoryConfirm': 'Категория "{name}" будет удалена.',
      'exitWithoutSaving': 'Выйти без сохранения?',
      'dataWillBeLost': 'Введённые данные будут потеряны.',
      'stay': 'Остаться',
      'exit': 'Выйти',
      'notSelected': 'Не выбрано',
      'exportPeriod': 'Период экспорта',
      'willBeExported': 'Будет экспортировано записей: {count}',
      'exporting': 'Формирование...',
      'exportToCsv': 'Экспортировать в CSV',
      'exportSuccess': 'Файл CSV успешно сформирован!',
      'exportError': 'Ошибка при экспорте: {error}',
      'noDataToExport': 'Нет данных для экспорта за выбранный период',
      'catFood': 'Еда',
      'catTransport': 'Транспорт',
      'catProducts': 'Продукты',
      'catEntertainment': 'Развлечения',
      'catHealth': 'Здоровье',
      'catOther': 'Другое',
      'newCategory': 'Новая категория',
      'editCategory': 'Редактировать категорию',
      'categoryName': 'Название',
      'cannotDeleteCategory': 'Невозможно удалить категорию',
      'categoryUsedInExpenses': 'Категория "{name}" используется в {count} расходах. Удалить её?',
      'deleteAnyway': 'Всё равно удалить',
      'icon': 'Иконка',
      'color': 'Цвет',
      'selectIcon': 'Выберите иконку',
      'selectColor': 'Выберите цвет',
      'categorySaved': 'Категория сохранена',
      'categoryDeleted': 'Категория удалена',
      'categoryAlreadyExists': 'Категория с таким названием уже существует',
      'invalidAmountRange': 'Сумма "От" должна быть меньше или равна "До"',
      'maxAmountExceeded': 'Сумма не может превышать 10 000 000',
    },
    'en': {
      'appName': 'Expense Tracker',
      'homeScreen': 'Expenses',
      'statsScreen': 'Statistics',
      'settingsScreen': 'Settings',
      'categoriesScreen': 'Categories',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'noExpenses': 'No expenses. Tap + to add.',
      'noCategories': 'No categories. Tap + to add.',
      'nothingFound': 'Nothing found',
      'search': 'Search...',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'addExpense': 'New Expense',
      'editExpense': 'Edit Expense',
      'title': 'Title',
      'description': 'Description',
      'amount': 'Amount',
      'date': 'Date',
      'category': 'Category',
      'exportCSV': 'Export to CSV',
      'theme': 'Dark theme',
      'language': 'Language',
      'currency': 'Currency',
      'navExpenses': 'Expenses',
      'navCategories': 'Categories',
      'navStats': 'Statistics',
      'navSettings': 'Settings',
      'currencySymbol': '\$', // ✅ ИСПРАВЛЕНО: добавлен экранирующий слэш
      'currencyName': 'Dollar',
      'period': 'Period',
      'week': 'Week',
      'month': 'Month',
      'custom': 'Custom',
      'apply': 'Apply',
      'reset': 'Reset',
      'filters': 'Filters',
      'from': 'From',
      'to': 'To',
      'totalForPeriod': 'Total for period',
      'byCategories': 'By categories',
      'byDays': 'By days',
      'unknown': 'Unknown',
      'enterTitle': 'Enter title',
      'enterAmount': 'Enter amount',
      'minAmount': 'Min amount',
      'maxAmount': 'Max amount',
      'enterPositiveNumber': 'Enter a positive number',
      'deleteExpense': 'Delete expense?',
      'cannotUndo': 'This action cannot be undone.',
      'deleteCategoryConfirm': 'Category "{name}" will be deleted.',
      'exitWithoutSaving': 'Exit without saving?',
      'dataWillBeLost': 'Entered data will be lost.',
      'stay': 'Stay',
      'exit': 'Exit',
      'notSelected': 'Not selected',
      'exportPeriod': 'Export period',
      'willBeExported': 'Records to be exported: {count}',
      'exporting': 'Generating...',
      'exportToCsv': 'Export to CSV',
      'exportSuccess': 'CSV file successfully generated!',
      'exportError': 'Export error: {error}',
      'noDataToExport': 'No data to export for the selected period',
      'catFood': 'Food',
      'catTransport': 'Transport',
      'catProducts': 'Groceries',
      'catEntertainment': 'Entertainment',
      'catHealth': 'Health',
      'catOther': 'Other',
      'newCategory': 'New category',
      'editCategory': 'Edit category',
      'categoryName': 'Name',
      'icon': 'Icon',
      'color': 'Color',
      'selectIcon': 'Select icon',
      'selectColor': 'Select color',
      'categorySaved': 'Category saved',
      'categoryDeleted': 'Category deleted',
      'categoryAlreadyExists': 'Category with this name already exists',
      'invalidAmountRange': 'Min amount must be less than or equal to Max amount',
      'maxAmountExceeded': 'Amount cannot exceed 10,000,000',
      'cannotDeleteCategory': 'Cannot delete category',
      'categoryUsedInExpenses': 'Category "{name}" is used in {count} expenses. Delete it anyway?',
      'deleteAnyway': 'Delete anyway',
    },
  };

  static String tr(String key, {Map<String, String>? params}) {
    final lang = appLocaleNotifier.value.languageCode;
    String text = translations[lang]?[key] ?? translations['ru']![key] ?? key;

    if (params != null) {
      params.forEach((key, value) {
        text = text.replaceAll('{$key}', value);
      });
    }

    return text;
  }

  /// Переводит название категории, если оно стандартное
  static String translateCategory(String categoryName) {
    const ruToKey = {
      'Еда': 'catFood',
      'Транспорт': 'catTransport',
      'Продукты': 'catProducts',
      'Развлечения': 'catEntertainment',
      'Здоровье': 'catHealth',
      'Другое': 'catOther',
    };

    const enToKey = {
      'Food': 'catFood',
      'Transport': 'catTransport',
      'Groceries': 'catProducts',
      'Entertainment': 'catEntertainment',
      'Health': 'catHealth',
      'Other': 'catOther',
    };

    String? key = ruToKey[categoryName] ?? enToKey[categoryName];

    if (key != null) {
      return tr(key);
    }

    return categoryName;
  }

  /// Возвращает символ текущей валюты
  static String getCurrencySymbol() {
    final currency = appCurrencyNotifier.value;
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'RUB':
      default:
        return '₽';
    }
  }
}