import 'package:flutter/material.dart';
import '../main.dart'; // Импортируем appLocaleNotifier
import '../core/localization/app_strings.dart';
import 'features/expenses/presentation/screens/home_screen.dart';
import 'features/categories/presentation/categories_screen.dart';
import 'features/stats/presentation/stats_screen.dart';
import 'features/settings/presentation/settings_screen.dart';

class MainShell extends StatefulWidget {
  final Function(bool?) onThemeChanged;

  const MainShell({super.key, required this.onThemeChanged});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const CategoriesScreen(),
      const StatsScreen(),
      SettingsScreen(onThemeChanged: widget.onThemeChanged),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      // ✅ Оборачиваем в ValueListenableBuilder, чтобы панель переводилась при смене языка
      bottomNavigationBar: ValueListenableBuilder<Locale>(
        valueListenable: appLocaleNotifier,
        builder: (context, locale, child) {
          return NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home),
                label: AppStrings.tr('navExpenses'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.category),
                label: AppStrings.tr('navCategories'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.pie_chart),
                label: AppStrings.tr('navStats'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings),
                label: AppStrings.tr('navSettings'),
              ),
            ],
          );
        },
      ),
    );
  }
}