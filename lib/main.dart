import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/theme_service.dart';
import 'services/settings_service.dart';
import 'main_shell.dart';

final ValueNotifier<Locale> appLocaleNotifier = ValueNotifier(const Locale('ru'));
final ValueNotifier<String> appCurrencyNotifier = ValueNotifier('RUB');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            return MaterialApp(
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
            );
          },
        );
      },
    );
  }

  ThemeData get _darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121218),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3D5A80),
      surface: Color(0xFF1E1E2E),
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121218),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF3D5A80),
    ),
  );

  ThemeData get _lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3D5A80),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF121218),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 1,
      iconTheme: IconThemeData(color: Color(0xFF121218)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF3D5A80),
      foregroundColor: Colors.white,
    ),
  );
}