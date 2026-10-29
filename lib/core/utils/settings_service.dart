import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsService {
  static const String _keyLocale = 'app_locale';
  static const String _keyCurrency = 'app_currency';

  /// Получить текущую локаль (по умолчанию 'ru')
  static Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_keyLocale) ?? 'ru';
    return Locale(langCode);
  }

  /// Сохранить новую локаль
  static Future<void> setLocale(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, langCode);
  }

  /// Получить текущую валюту (по умолчанию 'RUB')
  static Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrency) ?? 'RUB';
  }

  /// Сохранить новую валюту
  static Future<void> setCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrency, currencyCode);
  }
}