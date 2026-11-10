import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'isDarkTheme';

  // ✅ Возвращает bool? (null = системная тема)
  static Future<bool?> isDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Если ключа нет — возвращаем null (системная)
    if (!prefs.containsKey(_themeKey)) {
      return null;
    }
    return prefs.getBool(_themeKey);
  }

  // ✅ Принимает bool? (null = системная)
  static Future<void> setDarkTheme(bool? isDark) async {
    final prefs = await SharedPreferences.getInstance();
    if (isDark == null) {
      // Удаляем ключ — будет системная тема
      await prefs.remove(_themeKey);
    } else {
      await prefs.setBool(_themeKey, isDark);
    }
  }
}