import 'package:flutter/material.dart';

import 'finance_colors.dart';

class AppTheme {
  static const _fontFamily = 'Inter';

  static const _fontFeatures = [FontFeature.tabularFigures()];

  static ThemeData get lightTheme {
    const tokens = FinanceColors.light;
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: tokens.primary,
      onPrimary: tokens.onPrimary,
      secondary: tokens.primary,
      onSecondary: tokens.onPrimary,
      error: tokens.expense,
      onError: tokens.onPrimary,
      surface: tokens.surface,
      onSurface: tokens.onSurface,
      outline: tokens.outline,
    );

    return _buildTheme(colorScheme, tokens);
  }

  static ThemeData get darkTheme {
    const tokens = FinanceColors.dark;
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: tokens.primary,
      onPrimary: tokens.onPrimary,
      secondary: tokens.primary,
      onSecondary: tokens.onPrimary,
      error: tokens.expense,
      onError: tokens.onPrimary,
      surface: tokens.surface,
      onSurface: tokens.onSurface,
      outline: tokens.outline,
    );

    return _buildTheme(colorScheme, tokens);
  }

  static ThemeData _buildTheme(
    ColorScheme colorScheme,
    FinanceColors financeColors,
  ) {
    const radius16 = BorderRadius.all(Radius.circular(16));

    final textTheme = TextTheme(
      displayLarge: TextStyle(
        fontFamily: _fontFamily,
        fontFeatures: _fontFeatures,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: financeColors.onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontFeatures: _fontFeatures,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: financeColors.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontFeatures: _fontFeatures,
        fontSize: 16,
        color: financeColors.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontFeatures: _fontFeatures,
        fontSize: 14,
        color: financeColors.onSurface,
      ),
      labelSmall: TextStyle(
        fontFamily: _fontFamily,
        fontFeatures: _fontFeatures,
        fontSize: 13,
        color: financeColors.onSurfaceMuted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: financeColors.background,
      textTheme: textTheme,
      extensions: [financeColors],
      appBarTheme: AppBarTheme(
        backgroundColor: financeColors.surface,
        foregroundColor: financeColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: financeColors.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: radius16,
          side: BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: financeColors.surfaceVariant,
        border: const OutlineInputBorder(
          borderRadius: radius16,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: radius16,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius16,
          borderSide: BorderSide(color: financeColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: financeColors.primary,
          foregroundColor: financeColors.onPrimary,
          shape: const RoundedRectangleBorder(borderRadius: radius16),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: financeColors.primary,
          shape: const RoundedRectangleBorder(borderRadius: radius16),
          side: BorderSide(color: financeColors.outline),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: financeColors.primary,
        foregroundColor: financeColors.onPrimary,
        shape: const RoundedRectangleBorder(borderRadius: radius16),
        elevation: 2,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: financeColors.surface,
        contentTextStyle: TextStyle(
          color: financeColors.onSurface,
          fontFamily: _fontFamily,
          fontFeatures: _fontFeatures,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: radius16),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: financeColors.surface,
        indicatorColor: financeColors.surfaceVariant,
        elevation: 2,
      ),
    );
  }
}
