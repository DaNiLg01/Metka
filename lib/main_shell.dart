import 'package:flutter/material.dart';
import 'main.dart'; // ✅ ИСПРАВЛЕНО: простой импорт, так как файлы в одной папке
import 'core/localization/app_strings.dart';
import 'features/expenses/presentation/screens/home_screen.dart';
import 'features/categories/presentation/categories_screen.dart';
import 'features/stats/presentation/stats_screen.dart';
import 'features/settings/presentation/settings_screen.dart';

class MainShell extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const MainShell({super.key, required this.onThemeChanged});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<String>(
        valueListenable: appCurrencyNotifier,
        builder: (context, currency, child) {
          return IndexedStack(
            index: _selectedIndex,
            children: [
              KeyedSubtree(
                key: ValueKey('home_$currency'),
                child: const HomeScreen(),
              ),
              KeyedSubtree(
                key: ValueKey('categories_$currency'),
                child: const CategoriesScreen(),
              ),
              KeyedSubtree(
                key: ValueKey('stats_$currency'),
                child: const StatsScreen(),
              ),
              KeyedSubtree(
                key: ValueKey('settings_$currency'),
                child: SettingsScreen(onThemeChanged: widget.onThemeChanged),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: AppStrings.tr('navExpenses'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.category_outlined),
            selectedIcon: const Icon(Icons.category),
            label: AppStrings.tr('navCategories'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.pie_chart_outline),
            selectedIcon: const Icon(Icons.pie_chart),
            label: AppStrings.tr('navStats'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: AppStrings.tr('navSettings'),
          ),
        ],
      ),
    );
  }
}