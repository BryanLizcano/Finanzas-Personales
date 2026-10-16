import 'package:intl/intl.dart';

import 'currency.dart';

class Money implements Comparable<Money> {
  final int units;
  final Currency currency;

  const Money({required this.units, this.currency = Currency.cop});

  const Money.zero([this.currency = Currency.cop]) : units = 0;

  factory Money.fromMajor(int majorUnits, [Currency currency = Currency.cop]) {
    final factor = _pow10(currency.decimals);
    return Money(units: majorUnits * factor, currency: currency);
  }

  static int _pow10(int exp) {
    var result = 1;
    for (var i = 0; i < exp; i++) {
      result *= 10;
    }
    return result;
  }

  bool get isNegative => units < 0;
  bool get isZero => units == 0;
  bool get isPositive => units > 0;

  Money abs() => Money(units: units.abs(), currency: currency);

  void _checkSameCurrency(Money other) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Cannot perform arithmetic between different currencies: ${currency.code} and ${other.currency.code}',
      );
    }
  }

  Money operator +(Money other) {
    _checkSameCurrency(other);
    return Money(units: units + other.units, currency: currency);
  }

  Money operator -(Money other) {
    _checkSameCurrency(other);
    return Money(units: units - other.units, currency: currency);
  }

  Money operator *(int factor) {
    return Money(units: units * factor, currency: currency);
  }

  Money operator ~/(int divisor) {
    if (divisor == 0) {
      throw ArgumentError('Divisor cannot be zero');
    }
    return Money(units: units ~/ divisor, currency: currency);
  }

  /// Percentage calculation without double: (units * percent) ~/ 100
  Money percentage(int percent) {
    return Money(units: (units * percent) ~/ 100, currency: currency);
  }

  Money withCurrency(Currency newCurrency) {
    return Money(units: units, currency: newCurrency);
  }

  String format([String? locale]) {
    final effectiveLocale = locale ?? 'es';
    final isNegativeValue = units < 0;
    final absUnits = units.abs();

    if (currency.decimals == 0) {
      final numberFormat = NumberFormat.decimalPattern(effectiveLocale);
      final formattedNumber = numberFormat.format(absUnits);
      final sign = isNegativeValue ? '-' : '';
      return '$sign\$ $formattedNumber';
    } else {
      final factor = _pow10(currency.decimals);
      final major = absUnits ~/ factor;
      final minor = absUnits % factor;
      final minorStr = minor.toString().padLeft(currency.decimals, '0');
      final numberFormat = NumberFormat.decimalPattern(effectiveLocale);
      final formattedMajor = numberFormat.format(major);
      final decimalSep = effectiveLocale.startsWith('es') ? ',' : '.';
      final sign = isNegativeValue ? '-' : '';

      switch (currency) {
        case Currency.usd:
          return '$sign\$$formattedMajor$decimalSep$minorStr';
        case Currency.eur:
          return '$sign$formattedMajor$decimalSep$minorStr €';
        case Currency.cop:
          return '$sign\$ $formattedMajor';
      }
    }
  }

  @override
  int compareTo(Money other) {
    _checkSameCurrency(other);
    return units.compareTo(other.units);
  }

  bool operator <(Money other) => compareTo(other) < 0;
  bool operator <=(Money other) => compareTo(other) <= 0;
  bool operator >(Money other) => compareTo(other) > 0;
  bool operator >=(Money other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          units == other.units &&
          currency == other.currency;

  @override
  int get hashCode => Object.hash(units, currency);

  @override
  String toString() => '${currency.code} $units (lowest units)';
}
