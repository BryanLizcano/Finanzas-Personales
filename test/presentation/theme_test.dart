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
        expect(financeColors!.primary, const Color(0xFF2B5B6C));
        expect(financeColors.income, const Color(0xFF2E7D5B));
        expect(financeColors.expense, const Color(0xFFB84A4A));
        expect(financeColors.savings, const Color(0xFFB47B38));
        expect(financeColors.debt, const Color(0xFF5A5286));
      },
    );

    test(
      'Dark theme provides FinanceColors extension and M3 configuration',
      () {
        final dark = AppTheme.darkTheme;
        expect(dark.useMaterial3, isTrue);

        final financeColors = dark.extension<FinanceColors>();
        expect(financeColors, isNotNull);
        expect(financeColors!.primary, const Color(0xFF7FAEC2));
        expect(financeColors.income, const Color(0xFF5EBA8F));
        expect(financeColors.expense, const Color(0xFFE07A7A));
        expect(financeColors.savings, const Color(0xFFE2B46D));
        expect(financeColors.debt, const Color(0xFFA39BD2));
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
