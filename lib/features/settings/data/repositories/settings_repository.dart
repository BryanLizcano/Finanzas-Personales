import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/money/currency.dart';

enum AppThemeSetting {
  system,
  light,
  dark;

  ThemeMode get toThemeMode {
    switch (this) {
      case AppThemeSetting.light:
        return ThemeMode.light;
      case AppThemeSetting.dark:
        return ThemeMode.dark;
      case AppThemeSetting.system:
        return ThemeMode.system;
    }
  }

  static AppThemeSetting fromString(String val) {
    switch (val.toLowerCase()) {
      case 'light':
        return AppThemeSetting.light;
      case 'dark':
        return AppThemeSetting.dark;
      case 'system':
      default:
        return AppThemeSetting.system;
    }
  }
}

enum AppLanguageSetting {
  system,
  es,
  en;

  Locale? get toLocale {
    switch (this) {
      case AppLanguageSetting.es:
        return const Locale('es');
      case AppLanguageSetting.en:
        return const Locale('en');
      case AppLanguageSetting.system:
        return null;
    }
  }

  static AppLanguageSetting fromString(String val) {
    switch (val.toLowerCase()) {
      case 'es':
        return AppLanguageSetting.es;
      case 'en':
        return AppLanguageSetting.en;
      case 'system':
      default:
        return AppLanguageSetting.system;
    }
  }
}

class SettingsRepository {
  final SharedPreferences? _prefs;

  const SettingsRepository([this._prefs]);

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  Future<AppThemeSetting> getThemeSetting() async {
    final prefs = await _getPrefs();
    final val = prefs.getString('setting_theme_mode') ?? 'system';
    return AppThemeSetting.fromString(val);
  }

  Future<void> setThemeSetting(AppThemeSetting theme) async {
    final prefs = await _getPrefs();
    await prefs.setString('setting_theme_mode', theme.name);
  }

  Future<AppLanguageSetting> getLanguageSetting() async {
    final prefs = await _getPrefs();
    final val = prefs.getString('setting_language') ?? 'system';
    return AppLanguageSetting.fromString(val);
  }

  Future<void> setLanguageSetting(AppLanguageSetting lang) async {
    final prefs = await _getPrefs();
    await prefs.setString('setting_language', lang.name);
  }

  Future<Currency> getCurrencySetting() async {
    final prefs = await _getPrefs();
    final val = prefs.getString('setting_currency') ?? 'COP';
    return Currency.fromCode(val);
  }

  Future<void> setCurrencySetting(Currency currency) async {
    final prefs = await _getPrefs();
    await prefs.setString('setting_currency', currency.code);
  }

  Future<bool> isOnboardingCompleted() async {
    final prefs = await _getPrefs();
    return prefs.getBool('setting_onboarding_completed') ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await _getPrefs();
    await prefs.setBool('setting_onboarding_completed', completed);
  }
}
