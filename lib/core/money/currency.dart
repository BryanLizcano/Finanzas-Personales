enum Currency {
  cop,
  usd,
  eur;

  String get code => name.toUpperCase();

  int get decimals {
    switch (this) {
      case Currency.cop:
        return 0;
      case Currency.usd:
      case Currency.eur:
        return 2;
    }
  }

  String get symbol {
    switch (this) {
      case Currency.cop:
      case Currency.usd:
        return r'$';
      case Currency.eur:
        return '€';
    }
  }

  static Currency fromCode(String code) {
    switch (code.trim().toUpperCase()) {
      case 'COP':
        return Currency.cop;
      case 'USD':
        return Currency.usd;
      case 'EUR':
        return Currency.eur;
      default:
        return Currency.cop;
    }
  }
}
