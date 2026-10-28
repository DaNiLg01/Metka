import 'package:flutter/material.dart';
import '../services/app_strings.dart';
import '../services/settings_service.dart';
import '../main.dart';
import 'export_screen.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentLanguage = 'Русский (RU)';
  String _currentCurrency = 'Российский рубль (₽)';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final locale = await SettingsService.getLocale();
    final currency = await SettingsService.getCurrency();

    if (!mounted) return;

    setState(() {
      _currentLanguage = locale.languageCode == 'ru' ? 'Русский (RU)' : 'English (EN)';
      _currentCurrency = currency == 'RUB' ? 'Российский рубль (₽)'
          : currency == 'USD' ? 'Доллар США (\$)'
          : 'Евро (€)';
    });
  }

  Future<void> _changeLanguage(String langCode, String displayName) async {
    await SettingsService.setLocale(langCode);
    appLocaleNotifier.value = Locale(langCode);
    setState(() {
      _currentLanguage = displayName;
    });
  }

  Future<void> _changeCurrency(String code, String displayName) async {
    await SettingsService.setCurrency(code);
    appCurrencyNotifier.value = code;
    setState(() {
      _currentCurrency = displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = isDark ? Colors.white : const Color(0xFF121218);
    final subtitleColor = isDark ? const Color(0xFF8B8B9E) : const Color(0xFF666666);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.tr('settingsScreen'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Оформление
          Card(
            color: surfaceColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('theme'),
                    style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppStrings.tr('theme'),
                            style: TextStyle(color: textColor, fontSize: 16),
                          ),
                        ],
                      ),
                      Switch(
                        value: isDark,
                        onChanged: widget.onThemeChanged,
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Региональные настройки
          Card(
            color: surfaceColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('language'),
                    style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
                    title: Text(AppStrings.tr('language'), style: TextStyle(color: textColor, fontSize: 16)),
                    subtitle: Text(_currentLanguage, style: TextStyle(color: subtitleColor)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () => _showLanguageDialog(),
                  ),
                  const Divider(height: 1),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.primary),
                    title: Text(AppStrings.tr('currency'), style: TextStyle(color: textColor, fontSize: 16)),
                    subtitle: Text(_currentCurrency, style: TextStyle(color: subtitleColor)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () => _showCurrencyDialog(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Данные
          Card(
            color: surfaceColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('exportCSV'),
                    style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.file_download, color: Theme.of(context).colorScheme.primary),
                    title: Text(AppStrings.tr('exportCSV'), style: TextStyle(color: textColor, fontSize: 16)),
                    subtitle: Text('Сохранить историю расходов в файл', style: TextStyle(color: subtitleColor)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ExportScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(AppStrings.tr('language')),
        children: [
          SimpleDialogOption(
            onPressed: () { _changeLanguage('ru', 'Русский (RU)'); Navigator.pop(context); },
            child: const Text('Русский (RU)'),
          ),
          SimpleDialogOption(
            onPressed: () { _changeLanguage('en', 'English (EN)'); Navigator.pop(context); },
            child: const Text('English (EN)'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(AppStrings.tr('currency')),
        children: [
          SimpleDialogOption(
            onPressed: () { _changeCurrency('RUB', 'Российский рубль (₽)'); Navigator.pop(context); },
            child: const Text('Российский рубль (₽)'),
          ),
          SimpleDialogOption(
            onPressed: () { _changeCurrency('USD', 'Доллар США (\$)'); Navigator.pop(context); },
            child: const Text('Доллар США (\$)'),
          ),
          SimpleDialogOption(
            onPressed: () { _changeCurrency('EUR', 'Евро (€)'); Navigator.pop(context); },
            child: const Text('Евро (€)'),
          ),
        ],
      ),
    );
  }
}