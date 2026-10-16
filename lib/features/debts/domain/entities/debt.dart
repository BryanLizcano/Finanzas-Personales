enum DebtStrategy {
  avalanche,
  snowball;

  static DebtStrategy fromString(String val) {
    return val.toLowerCase() == 'snowball'
        ? DebtStrategy.snowball
        : DebtStrategy.avalanche;
  }
}

class DebtEntity {
  final int id;
  final String name;
  final String creditor;
  final int initialAmount;
  final int interestRateBp;
  final int minPayment;
  final int dueDay;
  final int priority;
  final bool archived;

  const DebtEntity({
    required this.id,
    required this.name,
    required this.creditor,
    required this.initialAmount,
    required this.interestRateBp,
    required this.minPayment,
    required this.dueDay,
    required this.priority,
    this.archived = false,
  });

  DebtEntity copyWith({
    String? name,
    String? creditor,
    int? initialAmount,
    int? interestRateBp,
    int? minPayment,
    int? dueDay,
    int? priority,
    bool? archived,
  }) {
    return DebtEntity(
      id: id,
      name: name ?? this.name,
      creditor: creditor ?? this.creditor,
      initialAmount: initialAmount ?? this.initialAmount,
      interestRateBp: interestRateBp ?? this.interestRateBp,
      minPayment: minPayment ?? this.minPayment,
      dueDay: dueDay ?? this.dueDay,
      priority: priority ?? this.priority,
      archived: archived ?? this.archived,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          creditor == other.creditor &&
          initialAmount == other.initialAmount &&
          interestRateBp == other.interestRateBp &&
          minPayment == other.minPayment &&
          dueDay == other.dueDay &&
          priority == other.priority &&
          archived == other.archived;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    creditor,
    initialAmount,
    interestRateBp,
    minPayment,
    dueDay,
    priority,
    archived,
  );
}

class DebtWithBalance {
  final DebtEntity debt;
  final int paidAmount;
  final int currentBalance;

  const DebtWithBalance({
    required this.debt,
    required this.paidAmount,
    required this.currentBalance,
  });

  bool get isPaidOff => currentBalance <= 0;

  double get progressRatio => debt.initialAmount == 0
      ? 1.0
      : (paidAmount / debt.initialAmount).clamp(0.0, 1.0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtWithBalance &&
          runtimeType == other.runtimeType &&
          debt == other.debt &&
          paidAmount == other.paidAmount &&
          currentBalance == other.currentBalance;

  @override
  int get hashCode => Object.hash(debt, paidAmount, currentBalance);
}
