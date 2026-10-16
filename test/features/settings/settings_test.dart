import 'package:finanzas_personales/core/money/currency.dart';
import 'package:finanzas_personales/features/settings/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group(
    'Settings & Preferences (T-003, T-004, T-009, RF-18, RF-19, RF-20)',
    () {
      late SharedPreferences prefs;
      late SettingsRepository repo;

      setUp(() async {
        SharedPreferences.setMockInitialValues({});
        prefs = await SharedPreferences.getInstance();
        repo = SettingsRepository(prefs);
      });

      test('theme settings persist and map to Flutter ThemeMode', () async {
        expect(await repo.getThemeSetting(), AppThemeSetting.system);
        expect(AppThemeSetting.system.toThemeMode, ThemeMode.system);

        await repo.setThemeSetting(AppThemeSetting.dark);
        expect(await repo.getThemeSetting(), AppThemeSetting.dark);
        expect(AppThemeSetting.dark.toThemeMode, ThemeMode.dark);
      });

      test('language settings persist and map to Flutter Locale', () async {
        expect(await repo.getLanguageSetting(), AppLanguageSetting.system);
        expect(AppLanguageSetting.system.toLocale, isNull);

        await repo.setLanguageSetting(AppLanguageSetting.es);
        expect(await repo.getLanguageSetting(), AppLanguageSetting.es);
        expect(AppLanguageSetting.es.toLocale, const Locale('es'));

        await repo.setLanguageSetting(AppLanguageSetting.en);
        expect(AppLanguageSetting.en.toLocale, const Locale('en'));
      });

      test('currency settings persist and map to Currency enum', () async {
        expect(await repo.getCurrencySetting(), Currency.cop);

        await repo.setCurrencySetting(Currency.usd);
        expect(await repo.getCurrencySetting(), Currency.usd);

        await repo.setCurrencySetting(Currency.eur);
        expect(await repo.getCurrencySetting(), Currency.eur);
      });

      test('onboarding completion persists boolean flag', () async {
        expect(await repo.isOnboardingCompleted(), isFalse);

        await repo.setOnboardingCompleted(true);
        expect(await repo.isOnboardingCompleted(), isTrue);
      });
    },
  );
}
