enum AccountType {
  cash,
  bank,
  savings;

  static AccountType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'bank':
        return AccountType.bank;
      case 'savings':
        return AccountType.savings;
      case 'cash':
      default:
        return AccountType.cash;
    }
  }
}

class Account {
  final int id;
  final String name;
  final AccountType type;
  final int initialBalance;
  final bool archived;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.initialBalance,
    this.archived = false,
  });

  Account copyWith({
    String? name,
    AccountType? type,
    int? initialBalance,
    bool? archived,
  }) {
    return Account(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      initialBalance: initialBalance ?? this.initialBalance,
      archived: archived ?? this.archived,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          initialBalance == other.initialBalance &&
          archived == other.archived;

  @override
  int get hashCode => Object.hash(id, name, type, initialBalance, archived);
}
