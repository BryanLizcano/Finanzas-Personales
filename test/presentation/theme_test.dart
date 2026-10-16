import 'package:finanzas_personales/app/theme/app_theme.dart';
import 'package:finanzas_personales/app/theme/finance_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Theme & Design Tokens (07_diseno_ui_ux.md)', () {
    test(
      'Light theme provides FinanceColors extension and M3 configuration',
      () {
        final light = AppTheme.lightTheme;
        expect(light.useMaterial3, isTrue);

        final financeColors = light.extension<FinanceColors>();
        expect(financeColors, isNotNull);
        expect(financeColors!.primary, const Color(0xFF0F766E));
        expect(financeColors.income, const Color(0xFF15803D));
        expect(financeColors.expense, const Color(0xFFDC2626));
        expect(financeColors.savings, const Color(0xFFB45309));
        expect(financeColors.debt, const Color(0xFF6D28D9));
      },
    );

    test(
      'Dark theme provides FinanceColors extension and M3 configuration',
      () {
        final dark = AppTheme.darkTheme;
        expect(dark.useMaterial3, isTrue);

        final financeColors = dark.extension<FinanceColors>();
        expect(financeColors, isNotNull);
        expect(financeColors!.primary, const Color(0xFF5EEAD4));
        expect(financeColors.income, const Color(0xFF4ADE80));
        expect(financeColors.expense, const Color(0xFFF87171));
        expect(financeColors.savings, const Color(0xFFFBBF24));
        expect(financeColors.debt, const Color(0xFFA78BFA));
      },
    );

    test('FinanceColors copyWith and lerp operate correctly', () {
      const colors = FinanceColors.light;
      final copied =
          colors.copyWith(primary: const Color(0xFF000000)) as FinanceColors;
      expect(copied.primary, const Color(0xFF000000));
      expect(copied.income, colors.income);

      final lerped = colors.lerp(FinanceColors.dark, 0.5);
      expect(lerped, isA<FinanceColors>());
    });
  });
}
