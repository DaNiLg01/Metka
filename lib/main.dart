import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/theme_service.dart';
import 'core/utils/settings_service.dart';
import 'core/theme/app_colors.dart';
import 'features/expenses/data/services/storage_service.dart'; // ✅ ДОБАВЛЕНО
import 'features/categories/data/category_service.dart'; // ✅ ДОБАВЛЕНО
import 'main_shell.dart';
import 'core/database/app_database.dart';

final AppDatabase database = AppDatabase();

final ValueNotifier<Locale> appLocaleNotifier = ValueNotifier(const Locale('ru'));
final ValueNotifier<String> appCurrencyNotifier = ValueNotifier('RUB');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ ИНИЦИАЛИЗАЦИЯ СЕРВИСОВ С ЕДИНЫМ ЭКЗЕМПЛЯРОМ БД
  StorageService.init(database);
  CategoryService.init(database);

  final isDark = await ThemeService.isDarkTheme();
  final locale = await SettingsService.getLocale();
  final currency = await SettingsService.getCurrency();

  appLocaleNotifier.value = locale;
  appCurrencyNotifier.value = currency;

  runApp(ExpenseApp(isDarkTheme: isDark));
}

class ExpenseApp extends StatefulWidget {
  final bool isDarkTheme;
  const ExpenseApp({super.key, required this.isDarkTheme});

  @override
  State<ExpenseApp> createState() => _ExpenseAppState();
}

class _ExpenseAppState extends State<ExpenseApp> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkTheme;
  }

  void toggleTheme(bool isDark) {
    setState(() {
      _isDark = isDark;
    });
    ThemeService.setDarkTheme(isDark);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocaleNotifier,
      builder: (context, locale, child) {
        return ValueListenableBuilder<String>(
          valueListenable: appCurrencyNotifier,
          builder: (context, currency, child) {
            return AnimatedTheme(
              data: _isDark ? _darkTheme : _lightTheme,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: MaterialApp(
                title: 'Учёт расходов',
                debugShowCheckedModeBanner: false,
                locale: locale,
                supportedLocales: const [
                  Locale('ru', 'RU'),
                  Locale('en', 'US'),
                ],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: _isDark ? _darkTheme : _lightTheme,
                home: MainShell(onThemeChanged: toggleTheme),
              ),
            );
          },
        );
      },
    );
  }

  // ✅ ТЁМНАЯ ТЕМА С AppColors
  ThemeData get _darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.textLight,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textLight,
      onSurfaceVariant: AppColors.textSecondaryDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textLight),
      titleTextStyle: TextStyle(
        color: AppColors.textLight,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textLight,
    ),
  );

  // ✅ СВЕТЛАЯ ТЕМА С AppColors
  ThemeData get _lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textDark,
      onSurfaceVariant: AppColors.textSecondaryLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      elevation: 1,
      iconTheme: IconThemeData(color: AppColors.textDark),
      titleTextStyle: TextStyle(
        color: AppColors.textDark,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textLight,
    ),
  );
}