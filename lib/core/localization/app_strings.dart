import '../../main.dart';

class AppStrings {
  static Map<String, Map<String, String>> translations = {
    'ru': {
      // ===== НАВИГАЦИЯ =====
      'appName': 'Учёт расходов',
      'navExpenses': 'Расходы',
      'navCategories': 'Категории',
      'navStats': 'Статистика',
      'navSettings': 'Настройки',

      // ===== ЭКРАНЫ =====
      'homeScreen': 'Расходы',
      'statsScreen': 'Статистика',
      'settingsScreen': 'Настройки',
      'categoriesScreen': 'Категории',

      // ===== ОБЩИЕ =====
      'save': 'Сохранить',
      'cancel': 'Отмена',
      'delete': 'Удалить',
      'apply': 'Применить',
      'reset': 'Сбросить',
      'search': 'Поиск...',
      'nothingFound': 'Ничего не найдено',
      'today': 'Сегодня',
      'yesterday': 'Вчера',
      'noExpenses': 'Нет расходов. Нажмите +, чтобы добавить.',
      'noCategories': 'Нет категорий. Нажмите +, чтобы добавить.',

      // ===== РАСХОДЫ =====
      'addExpense': 'Новый расход',
      'editExpense': 'Редактировать расход',
      'title': 'Название',
      'description': 'Описание',
      'amount': 'Сумма',
      'date': 'Дата',
      'category': 'Категория',
      'enterTitle': 'Введите название',
      'enterAmount': 'Введите сумму',
      'enterPositiveNumber': 'Введите положительное число',
      'maxAmountExceeded': 'Сумма не может превышать 10 000 000',
      'deleteExpense': 'Удалить расход?',
      'cannotUndo': 'Это действие нельзя отменить.',
      'exitWithoutSaving': 'Выйти без сохранения?',
      'dataWillBeLost': 'Введённые данные будут потеряны.',
      'stay': 'Остаться',
      'exit': 'Выйти',

      // ===== КАТЕГОРИИ =====
      'newCategory': 'Новая категория',
      'editCategory': 'Редактировать категорию',
      'categoryName': 'Название',
      'icon': 'Иконка',
      'color': 'Цвет',
      'selectIcon': 'Выберите иконку',
      'selectColor': 'Выберите цвет',
      'categorySaved': 'Категория сохранена',
      'categoryDeleted': 'Категория удалена',
      'categoryAlreadyExists': 'Категория с таким названием уже существует',
      'cannotDeleteCategory': 'Невозможно удалить категорию',
      'categoryUsedInExpenses': 'Категория "{name}" используется в {count} расходах. Удалить её?',
      'deleteAnyway': 'Всё равно удалить',
      'deleteCategoryConfirm': 'Категория "{name}" будет удалена.',

      // ===== КАТЕГОРИИ (ПЕРЕВОДЫ) =====
      'catFood': 'Еда',
      'catTransport': 'Транспорт',
      'catProducts': 'Продукты',
      'catEntertainment': 'Развлечения',
      'catHealth': 'Здоровье',
      'catOther': 'Другое',

      // ===== ФИЛЬТРЫ =====
      'filters': 'Фильтры',
      'dateRange': 'Период дат',
      'startDate': 'Дата начала',
      'endDate': 'Дата окончания',
      'sumFrom': 'Сумма от',
      'sumTo': 'Сумма до',
      'minAmount': 'Сумма от',
      'maxAmount': 'Сумма до',
      'invalidAmountRange': 'Сумма "от" не может быть больше суммы "до"',
      'categories': 'Категории',

      // ===== СТАТИСТИКА =====
      'period': 'Период',
      'week': 'Неделя',
      'month': 'Месяц',
      'custom': 'Произвольный',
      'totalForPeriod': 'Всего за период',
      'byCategories': 'По категориям',
      'byDays': 'По дням',
      'notSelected': 'Не выбрано',

      // ===== НАСТРОЙКИ =====
      'settings': 'Настройки',
      'theme': 'Тема',
      'light': 'Светлая',
      'dark': 'Тёмная',
      'system': 'Системная',
      'language': 'Язык',
      'russian': 'Русский',
      'english': 'English',
      'currency': 'Валюта',
      'currencySymbol': '₽',
      'currencyName': 'Рубль',

      // ===== ЭКСПОРТ =====
      'exportCSV': 'Экспорт в CSV',
      'exportPeriod': 'Период экспорта',
      'willBeExported': 'Будет экспортировано записей: {count}',
      'exporting': 'Формирование...',
      'exportToCsv': 'Экспортировать в CSV',
      'exportSuccess': 'Файл CSV успешно сформирован!',
      'exportError': 'Ошибка при экспорте: {error}',
      'noDataToExport': 'Нет данных для экспорта за выбранный период',

      // ===== ПРОЧЕЕ =====
      'unknown': 'Неизвестно',
      'from': 'С',
      'to': 'По',
    },

    'en': {
      // ===== NAVIGATION =====
      'appName': 'Expense Tracker',
      'navExpenses': 'Expenses',
      'navCategories': 'Categories',
      'navStats': 'Statistics',
      'navSettings': 'Settings',

      // ===== SCREENS =====
      'homeScreen': 'Expenses',
      'statsScreen': 'Statistics',
      'settingsScreen': 'Settings',
      'categoriesScreen': 'Categories',

      // ===== COMMON =====
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'apply': 'Apply',
      'reset': 'Reset',
      'search': 'Search...',
      'nothingFound': 'Nothing found',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'noExpenses': 'No expenses. Tap + to add.',
      'noCategories': 'No categories. Tap + to add.',

      // ===== EXPENSES =====
      'addExpense': 'New Expense',
      'editExpense': 'Edit Expense',
      'title': 'Title',
      'description': 'Description',
      'amount': 'Amount',
      'date': 'Date',
      'category': 'Category',
      'enterTitle': 'Enter title',
      'enterAmount': 'Enter amount',
      'enterPositiveNumber': 'Enter a positive number',
      'maxAmountExceeded': 'Amount cannot exceed 10,000,000',
      'deleteExpense': 'Delete expense?',
      'cannotUndo': 'This action cannot be undone.',
      'exitWithoutSaving': 'Exit without saving?',
      'dataWillBeLost': 'Entered data will be lost.',
      'stay': 'Stay',
      'exit': 'Exit',

      // ===== CATEGORIES =====
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
      'cannotDeleteCategory': 'Cannot delete category',
      'categoryUsedInExpenses': 'Category "{name}" is used in {count} expenses. Delete it anyway?',
      'deleteAnyway': 'Delete anyway',
      'deleteCategoryConfirm': 'Category "{name}" will be deleted.',

      // ===== CATEGORIES (TRANSLATIONS) =====
      'catFood': 'Food',
      'catTransport': 'Transport',
      'catProducts': 'Groceries',
      'catEntertainment': 'Entertainment',
      'catHealth': 'Health',
      'catOther': 'Other',

      // ===== FILTERS =====
      'filters': 'Filters',
      'dateRange': 'Date Range',
      'startDate': 'Start Date',
      'endDate': 'End Date',
      'sumFrom': 'Sum From',
      'sumTo': 'Sum To',
      'minAmount': 'Min amount',
      'maxAmount': 'Max amount',
      'invalidAmountRange': 'Min amount must be less than or equal to Max amount',
      'categories': 'Categories',

      // ===== STATISTICS =====
      'period': 'Period',
      'week': 'Week',
      'month': 'Month',
      'custom': 'Custom',
      'totalForPeriod': 'Total for period',
      'byCategories': 'By categories',
      'byDays': 'By days',
      'notSelected': 'Not selected',

      // ===== SETTINGS =====
      'settings': 'Settings',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'language': 'Language',
      'russian': 'Russian',
      'english': 'English',
      'currency': 'Currency',
      'currencySymbol': '\$',
      'currencyName': 'Dollar',

      // ===== EXPORT =====
      'exportCSV': 'Export to CSV',
      'exportPeriod': 'Export period',
      'willBeExported': 'Records to be exported: {count}',
      'exporting': 'Generating...',
      'exportToCsv': 'Export to CSV',
      'exportSuccess': 'CSV file successfully generated!',
      'exportError': 'Export error: {error}',
      'noDataToExport': 'No data to export for the selected period',

      // ===== OTHER =====
      'unknown': 'Unknown',
      'from': 'From',
      'to': 'To',
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