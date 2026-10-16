import 'package:finanzas_personales/core/money/currency.dart';
import 'package:finanzas_personales/core/money/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money', () {
    test(
      'RN-01: amounts are integer units with currency-specific decimals',
      () {
        const cop = Money(units: 1250000, currency: Currency.cop);
        expect(cop.units, 1250000);
        expect(cop.currency.decimals, 0);

        const usd = Money(units: 125000, currency: Currency.usd);
        expect(usd.units, 125000);
        expect(usd.currency.decimals, 2);

        const eur = Money(units: 5095, currency: Currency.eur);
        expect(eur.units, 5095);
        expect(eur.currency.decimals, 2);
      },
    );

    test('RN-02: changing currency does not convert amount, only formats', () {
      const amount = Money(units: 100000, currency: Currency.cop);
      final changed = amount.withCurrency(Currency.usd);

      expect(changed.units, 100000);
      expect(changed.currency, Currency.usd);
      expect(changed.format('es'), r'$1.000,00');
    });

    test('RN-03: arithmetic with different currencies throws error', () {
      const cop = Money(units: 1000, currency: Currency.cop);
      const usd = Money(units: 1000, currency: Currency.usd);

      expect(() => cop + usd, throwsArgumentError);
      expect(() => cop - usd, throwsArgumentError);
    });

    test('performs integer arithmetic and percentage without double', () {
      const m1 = Money(units: 1000, currency: Currency.cop);
      const m2 = Money(units: 500, currency: Currency.cop);

      expect((m1 + m2).units, 1500);
      expect((m1 - m2).units, 500);
      expect((m1 * 3).units, 3000);
      expect((m1 ~/ 2).units, 500);
      expect(m1.percentage(50).units, 500);
      expect(m1.percentage(33).units, 330);
    });

    test('formats correctly according to currency and locale', () {
      const cop = Money(units: 1250000, currency: Currency.cop);
      expect(cop.format('es'), r'$ 1.250.000');

      const usd = Money(units: 125050, currency: Currency.usd);
      expect(usd.format('en'), r'$1,250.50');
      expect(usd.format('es'), r'$1.250,50');

      const eur = Money(units: 125000, currency: Currency.eur);
      expect(eur.format('es'), '1.250,00 €');
    });

    test('comparison operators work correctly', () {
      const m1 = Money(units: 100, currency: Currency.cop);
      const m2 = Money(units: 200, currency: Currency.cop);
      const m3 = Money(units: 100, currency: Currency.cop);

      expect(m1 < m2, isTrue);
      expect(m2 > m1, isTrue);
      expect(m1 <= m3, isTrue);
      expect(m1 == m3, isTrue);
    });
  });
}
