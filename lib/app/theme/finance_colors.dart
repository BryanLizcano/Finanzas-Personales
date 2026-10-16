import 'package:flutter/material.dart';

@immutable
class FinanceColors extends ThemeExtension<FinanceColors> {
  final Color primary;
  final Color onPrimary;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color income;
  final Color expense;
  final Color savings;
  final Color debt;
  final Color outline;

  const FinanceColors({
    required this.primary,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.income,
    required this.expense,
    required this.savings,
    required this.debt,
    required this.outline,
  });

  static const light = FinanceColors(
    primary: Color(0xFF0F766E),
    onPrimary: Color(0xFFFFFFFF),
    background: Color(0xFFF6F8F7),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFE5EDEB),
    onSurface: Color(0xFF14201E),
    onSurfaceMuted: Color(0xFF51625F),
    income: Color(0xFF15803D),
    expense: Color(0xFFDC2626),
    savings: Color(0xFFB45309),
    debt: Color(0xFF6D28D9),
    outline: Color(0xFFC5D2CF),
  );

  static const dark = FinanceColors(
    primary: Color(0xFF5EEAD4),
    onPrimary: Color(0xFF042F2E),
    background: Color(0xFF0E1514),
    surface: Color(0xFF162120),
    surfaceVariant: Color(0xFF223230),
    onSurface: Color(0xFFE6EDEB),
    onSurfaceMuted: Color(0xFF9DB1AD),
    income: Color(0xFF4ADE80),
    expense: Color(0xFFF87171),
    savings: Color(0xFFFBBF24),
    debt: Color(0xFFA78BFA),
    outline: Color(0xFF34504C),
  );

  @override
  ThemeExtension<FinanceColors> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? onSurface,
    Color? onSurfaceMuted,
    Color? income,
    Color? expense,
    Color? savings,
    Color? debt,
    Color? outline,
  }) {
    return FinanceColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      savings: savings ?? this.savings,
      debt: debt ?? this.debt,
      outline: outline ?? this.outline,
    );
  }

  @override
  ThemeExtension<FinanceColors> lerp(
    covariant ThemeExtension<FinanceColors>? other,
    double t,
  ) {
    if (other is! FinanceColors) return this;
    return FinanceColors(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t) ?? onPrimary,
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceVariant:
          Color.lerp(surfaceVariant, other.surfaceVariant, t) ?? surfaceVariant,
      onSurface: Color.lerp(onSurface, other.onSurface, t) ?? onSurface,
      onSurfaceMuted:
          Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t) ?? onSurfaceMuted,
      income: Color.lerp(income, other.income, t) ?? income,
      expense: Color.lerp(expense, other.expense, t) ?? expense,
      savings: Color.lerp(savings, other.savings, t) ?? savings,
      debt: Color.lerp(debt, other.debt, t) ?? debt,
      outline: Color.lerp(outline, other.outline, t) ?? outline,
    );
  }
}

extension BuildContextFinanceColors on BuildContext {
  FinanceColors get colors {
    return Theme.of(this).extension<FinanceColors>() ?? FinanceColors.light;
  }
}
