import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'services/theme_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);

  final isDark = await ThemeService.isDarkTheme();

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
    return MaterialApp(
      title: 'Расходы',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ru', 'RU'),
      theme: _isDark ? _darkTheme : _lightTheme,
      home: HomeScreen(onThemeChanged: toggleTheme),
    );
  }

  // Тёмная тема
  ThemeData get _darkTheme => ThemeData(
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

  // Светлая тема
  ThemeData get _lightTheme => ThemeData(
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