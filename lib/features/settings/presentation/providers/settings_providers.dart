import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/money/currency.dart';
import '../../data/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return const SettingsRepository();
});

class ThemeSettingNotifier extends Notifier<AppThemeSetting> {
  @override
  AppThemeSetting build() {
    _load();
    return AppThemeSetting.system;
  }

  Future<void> _load() async {
    final repo = ref.read(settingsRepositoryProvider);
    state = await repo.getThemeSetting();
  }

  Future<void> setTheme(AppThemeSetting theme) async {
    state = theme;
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setThemeSetting(theme);
  }
}

final themeSettingProvider =
    NotifierProvider<ThemeSettingNotifier, AppThemeSetting>(
      ThemeSettingNotifier.new,
    );

class LanguageSettingNotifier extends Notifier<AppLanguageSetting> {
  @override
  AppLanguageSetting build() {
    _load();
    return AppLanguageSetting.system;
  }

  Future<void> _load() async {
    final repo = ref.read(settingsRepositoryProvider);
    state = await repo.getLanguageSetting();
  }

  Future<void> setLanguage(AppLanguageSetting lang) async {
    state = lang;
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setLanguageSetting(lang);
  }
}

final languageSettingProvider =
    NotifierProvider<LanguageSettingNotifier, AppLanguageSetting>(
      LanguageSettingNotifier.new,
    );

class CurrencySettingNotifier extends Notifier<Currency> {
  @override
  Currency build() {
    _load();
    return Currency.cop;
  }

  Future<void> _load() async {
    final repo = ref.read(settingsRepositoryProvider);
    state = await repo.getCurrencySetting();
  }

  Future<void> setCurrency(Currency currency) async {
    state = currency;
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setCurrencySetting(currency);
  }
}

final currencySettingProvider =
    NotifierProvider<CurrencySettingNotifier, Currency>(
      CurrencySettingNotifier.new,
    );

class OnboardingCompletedNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    final repo = ref.read(settingsRepositoryProvider);
    state = await repo.isOnboardingCompleted();
  }

  Future<void> completeOnboarding() async {
    state = true;
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setOnboardingCompleted(true);
  }
}

final onboardingCompletedProvider =
    NotifierProvider<OnboardingCompletedNotifier, bool>(
      OnboardingCompletedNotifier.new,
    );
