import 'package:flutter/material.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_service.dart';
import '../../../../core/utils/settings_service.dart';
import '../../../../main.dart';
import '../../export/presentation/export_screen.dart'; // ✅ Добавлен импорт

class SettingsScreen extends StatefulWidget {
  final Function(bool?) onThemeChanged;
  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? _isDark;
  String _currency = 'RUB';
  Locale _locale = const Locale('ru');

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isDark = await ThemeService.isDarkTheme();
    final currency = await SettingsService.getCurrency();
    final locale = await SettingsService.getLocale();

    if (mounted) {
      setState(() {
        _isDark = isDark;
        _currency = currency;
        _locale = locale;
      });
    }
  }

  void _onThemeChanged(bool? value) {
    setState(() { _isDark = value; });
    widget.onThemeChanged(value);
  }

  void _onLanguageChanged(Locale locale) {
    setState(() { _locale = locale; });
    appLocaleNotifier.value = locale;
    SettingsService.setLocale(locale.languageCode);
  }

  void _onCurrencyChanged(String currency) {
    setState(() { _currency = currency; });
    appCurrencyNotifier.value = currency;
    SettingsService.setCurrency(currency);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
        title: Text(
          AppStrings.tr('settings'),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? AppColors.textLight : Colors.black87),
        ),
        iconTheme: IconThemeData(color: isDark ? AppColors.textLight : Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== ТЕМА =====
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.tr('theme'), style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _ThemeOption(label: AppStrings.tr('light'), isSelected: _isDark == false, onTap: () => _onThemeChanged(false), colorScheme: colorScheme)),
                      const SizedBox(width: 8),
                      Expanded(child: _ThemeOption(label: AppStrings.tr('dark'), isSelected: _isDark == true, onTap: () => _onThemeChanged(true), colorScheme: colorScheme)),
                      const SizedBox(width: 8),
                      Expanded(child: _ThemeOption(label: AppStrings.tr('system'), isSelected: _isDark == null, onTap: () => _onThemeChanged(null), colorScheme: colorScheme)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ===== ЯЗЫК =====
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.tr('language'), style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _onLanguageChanged(const Locale('ru')),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _locale.languageCode == 'ru' ? colorScheme.primary.withOpacity(0.1) : null,
                            side: BorderSide(color: _locale.languageCode == 'ru' ? colorScheme.primary : colorScheme.outline),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(AppStrings.tr('russian'), style: TextStyle(color: _locale.languageCode == 'ru' ? colorScheme.primary : colorScheme.onSurface)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _onLanguageChanged(const Locale('en')),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _locale.languageCode == 'en' ? colorScheme.primary.withOpacity(0.1) : null,
                            side: BorderSide(color: _locale.languageCode == 'en' ? colorScheme.primary : colorScheme.outline),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(AppStrings.tr('english'), style: TextStyle(color: _locale.languageCode == 'en' ? colorScheme.primary : colorScheme.onSurface)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ===== ВАЛЮТА =====
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.tr('currency'), style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _currency,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colorScheme.outline)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'RUB', child: Text('Рубль (₽)')),
                      DropdownMenuItem(value: 'USD', child: Text('Доллар (\$)')),
                      DropdownMenuItem(value: 'EUR', child: Text('Евро (€)')),
                    ],
                    onChanged: (value) { if (value != null) _onCurrencyChanged(value); },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ✅ НОВОЕ: ЭКСПОРТ ДАННЫХ (BUG-09)
          Card(
            color: colorScheme.surface,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.download, color: colorScheme.primary, size: 28),
              ),
              title: Text(AppStrings.tr('exportToCsv'), style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: Text(AppStrings.tr('exportPeriod'), style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14)),
              trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ExportScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _ThemeOption({required this.label, required this.isSelected, required this.onTap, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : null,
          border: Border.all(color: isSelected ? colorScheme.primary : colorScheme.outline, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? colorScheme.primary : colorScheme.onSurface, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 14)),
      ),
    );
  }
}