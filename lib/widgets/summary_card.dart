import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart'; // Импортируем глобальные нотифаеры валюты и языка

class SummaryCard extends StatelessWidget {
  final double total;

  const SummaryCard({super.key, required this.total});

  /// Получение символа валюты на основе настроек
  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'RUB':
      default:
        return '₽';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Получаем текущие настройки из глобальных переменных
    final currencyCode = appCurrencyNotifier.value;
    final localeCode = appLocaleNotifier.value.languageCode;
    final currencySymbol = _getCurrencySymbol(currencyCode);

    // Форматируем число с пробелами (например, 1 250 000)
    // Используем локаль, соответствующую выбранному языку
    final formatter = NumberFormat('#,##0', localeCode == 'ru' ? 'ru_RU' : 'en_US');
    final formattedTotal = formatter.format(total);

    // Получаем название текущего месяца на выбранном языке
    final monthName = DateFormat('MMMM', localeCode).format(DateTime.now()).toLowerCase();

    // Делаем первую букву заглавной для красоты (например, "Октябрь" или "October")
    final displayMonth = monthName.isNotEmpty
        ? monthName[0].toUpperCase() + monthName.substring(1)
        : monthName;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'За $displayMonth',
            style: TextStyle(
              fontSize: 16,
              // ✅ ИСПРАВЛЕНО: Убран хардкод цвета, используется цвет темы
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            // Если в дизайне нужен минус перед суммой, оставь '- '. Если нет, просто убери его.
            '- $formattedTotal $currencySymbol',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              // ✅ ИСПРАВЛЕНО: Убран хардкод цвета, используется цвет темы
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}