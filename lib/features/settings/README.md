# Feature: Settings & Preferences

## Propósito
Persistencia del estado global de configuración de la aplicación: modo de tema (sistema, claro, oscuro), idioma (sistema, español, inglés), divisa de visualización (COP, USD, EUR) y estado de primer arranque / bienvenida (onboarding completado).

## Providers Públicos

| Provider | Tipo | Qué devuelve / Métodos |
|---|---|---|
| `themeSettingProvider` | `NotifierProvider<ThemeSettingNotifier, AppThemeSetting>` | `state`: `system`, `light`, `dark`. Método: `setTheme(AppThemeSetting)` |
| `languageSettingProvider` | `NotifierProvider<LanguageSettingNotifier, AppLanguageSetting>` | `state`: `system`, `es`, `en`. Método: `setLanguage(AppLanguageSetting)` |
| `currencySettingProvider` | `NotifierProvider<CurrencySettingNotifier, Currency>` | `state`: `Currency.cop`, `Currency.usd`, `Currency.eur`. Método: `setCurrency(Currency)` |
| `onboardingCompletedProvider` | `NotifierProvider<OnboardingCompletedNotifier, bool>` | `state`: `bool`. Método: `completeOnboarding()` |

## Ejemplo de Uso en la UI
```dart
// En app.dart:
final themeSetting = ref.watch(themeSettingProvider);
final langSetting = ref.watch(languageSettingProvider);

return MaterialApp(
  themeMode: themeSetting.toThemeMode,
  locale: langSetting.toLocale,
  // ...
);

// En ajustes:
ref.read(currencySettingProvider.notifier).setCurrency(Currency.usd);
```
