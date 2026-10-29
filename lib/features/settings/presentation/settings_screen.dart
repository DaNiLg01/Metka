import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/theme_service.dart';
import '../../../core/utils/settings_service.dart';
import '../../../main.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged; // ✅ ДОБАВЛЕНО

  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;
  String _currentLanguage = 'ru';
  String _currentCurrency = 'RUB';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isDark = await ThemeService.isDarkTheme();
    final locale = await SettingsService.getLocale();
    final currency = await SettingsService.getCurrency();

    setState(() {
      _isDarkTheme = isDark;
      _currentLanguage = locale.languageCode;
      _currentCurrency = currency;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    setState(() {
      _isDarkTheme = value;
    });
    await ThemeService.setDarkTheme(value);

    // ✅ ИСПРАВЛЕНО: Сообщаем главному приложению о смене темы
    widget.onThemeChanged(value);
  }

  Future<void> _changeLanguage(String languageCode) async {
    setState(() {
      _currentLanguage = languageCode;
    });
    await SettingsService.setLocale(languageCode);
    appLocaleNotifier.value = Locale(languageCode);
  }

  Future<void> _changeCurrency(String currency) async {
    setState(() {
      _currentCurrency = currency;
    });
    await SettingsService.setCurrency(currency);
    appCurrencyNotifier.value = currency;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = colorScheme.surface;
    final textColor = colorScheme.onSurface;
    final subtitleColor = colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.tr('settingsScreen'),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: surfaceColor,
            child: SwitchListTile(
              title: Text(
                AppStrings.tr('theme'),
                style: TextStyle(color: textColor, fontSize: 16),
              ),
              subtitle: Text(
                _isDarkTheme ? 'Тёмная' : 'Светлая',
                style: TextStyle(color: subtitleColor),
              ),
              value: _isDarkTheme,
              activeColor: colorScheme.primary,
              onChanged: _toggleTheme,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: surfaceColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('language'),
                    style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _LanguageButton(
                          label: 'Русский',
                          isSelected: _currentLanguage == 'ru',
                          onTap: () => _changeLanguage('ru'),
                          textColor: textColor,
                          primaryColor: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _LanguageButton(
                          label: 'English',
                          isSelected: _currentLanguage == 'en',
                          onTap: () => _changeLanguage('en'),
                          textColor: textColor,
                          primaryColor: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: surfaceColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('currency'),
                    style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _currentCurrency,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'RUB', child: Text('Рубль (₽)')),
                      DropdownMenuItem(value: 'USD', child: Text('Доллар (\$)')),
                      DropdownMenuItem(value: 'EUR', child: Text('Евро (€)')),
                    ],
                    onChanged: (value) {
                      if (value != null) _changeCurrency(value);
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
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color textColor;
  final Color primaryColor;

  const _LanguageButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.textColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? primaryColor : textColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? primaryColor : textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}