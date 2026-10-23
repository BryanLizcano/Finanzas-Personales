import 'package:flutter/material.dart';

import 'finance_colors.dart';

class AppTheme {
  static const _fontFamily = 'Plus Jakarta Sans';
  static const _fontFallback = <String>[
    'Outfit',
    'DM Sans',
    'Segoe UI',
    'Roboto',
    'sans-serif',
  ];

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
    const radius18 = BorderRadius.all(Radius.circular(18));

    final textTheme = TextTheme(
      displayLarge: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFallback,
        fontFeatures: _fontFeatures,
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        height: 1.18,
        color: financeColors.onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFallback,
        fontFeatures: _fontFeatures,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        height: 1.25,
        color: financeColors.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFallback,
        fontFeatures: _fontFeatures,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
        color: financeColors.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFallback,
        fontFeatures: _fontFeatures,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
        height: 1.35,
        color: financeColors.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFallback,
        fontFeatures: _fontFeatures,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: financeColors.onSurface,
      ),
      labelSmall: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFallback,
        fontFeatures: _fontFeatures,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.3,
        color: financeColors.onSurfaceMuted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      fontFamilyFallback: _fontFallback,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: financeColors.background,
      textTheme: textTheme,
      extensions: [financeColors],
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: financeColors.background,
        foregroundColor: financeColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: financeColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: radius18,
          side: BorderSide(
            color: financeColors.outline.withValues(alpha: 0.28),
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: financeColors.surfaceVariant,
        border: const OutlineInputBorder(
          borderRadius: radius18,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: radius18,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius18,
          borderSide: BorderSide(color: financeColors.primary, width: 1.8),
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
          shape: const RoundedRectangleBorder(borderRadius: radius18),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: financeColors.primary,
          shape: const RoundedRectangleBorder(borderRadius: radius18),
          side: BorderSide(color: financeColors.outline),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: financeColors.primary,
        foregroundColor: financeColors.onPrimary,
        shape: const RoundedRectangleBorder(borderRadius: radius18),
        elevation: 2,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: financeColors.surface,
        contentTextStyle: TextStyle(
          color: financeColors.onSurface,
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontFeatures: _fontFeatures,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: radius18),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: financeColors.surface,
        indicatorColor: financeColors.surfaceVariant,
        elevation: 1,
      ),
    );
  }
}
