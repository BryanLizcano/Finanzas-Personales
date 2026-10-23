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
    primary: Color(0xFF2B5B6C),
    onPrimary: Color(0xFFFFFFFF),
    background: Color(0xFFF3F6F8),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFE6ECF0),
    onSurface: Color(0xFF1E293B),
    onSurfaceMuted: Color(0xFF64748B),
    income: Color(0xFF2E7D5B),
    expense: Color(0xFFB84A4A),
    savings: Color(0xFFB47B38),
    debt: Color(0xFF5A5286),
    outline: Color(0xFFCBD5E1),
  );

  static const dark = FinanceColors(
    primary: Color(0xFF7FAEC2),
    onPrimary: Color(0xFF0F1E26),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    surfaceVariant: Color(0xFF283548),
    onSurface: Color(0xFFF1F5F9),
    onSurfaceMuted: Color(0xFF94A3B8),
    income: Color(0xFF5EBA8F),
    expense: Color(0xFFE07A7A),
    savings: Color(0xFFE2B46D),
    debt: Color(0xFFA39BD2),
    outline: Color(0xFF334155),
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
