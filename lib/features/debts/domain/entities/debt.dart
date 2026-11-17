enum DebtStrategy {
  avalanche,
  snowball;

  static DebtStrategy fromString(String val) {
    return val.toLowerCase() == 'snowball'
        ? DebtStrategy.snowball
        : DebtStrategy.avalanche;
  }
}

enum DebtType {
  personal,
  creditCard,
  loan;

  static DebtType fromString(String val) {
    switch (val.toLowerCase()) {
      case 'credit_card':
      case 'creditcard':
        return DebtType.creditCard;
      case 'loan':
        return DebtType.loan;
      case 'personal':
      default:
        return DebtType.personal;
    }
  }

  String get dbValue => switch (this) {
    DebtType.personal => 'personal',
    DebtType.creditCard => 'credit_card',
    DebtType.loan => 'loan',
  };
}

enum DebtFrequency {
  inDays,
  biweekly,
  monthly;

  static DebtFrequency fromString(String val) {
    switch (val.toLowerCase()) {
      case 'in_days':
      case 'indays':
        return DebtFrequency.inDays;
      case 'biweekly':
        return DebtFrequency.biweekly;
      case 'monthly':
      default:
        return DebtFrequency.monthly;
    }
  }

  String get dbValue => switch (this) {
    DebtFrequency.inDays => 'in_days',
    DebtFrequency.biweekly => 'biweekly',
    DebtFrequency.monthly => 'monthly',
  };
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
  final DebtType debtType;
  final bool hasManagementFee;
  final int managementFee;
  final DebtFrequency frequencyType;
  final int? intervalDays;
  final DateTime? nextDueDate;

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
    this.debtType = DebtType.personal,
    this.hasManagementFee = false,
    this.managementFee = 0,
    this.frequencyType = DebtFrequency.monthly,
    this.intervalDays,
    this.nextDueDate,
  });

  int get effectiveManagementFee =>
      (debtType != DebtType.personal && hasManagementFee && managementFee > 0)
      ? managementFee
      : 0;

  bool get hasInterest => interestRateBp > 0;

  DebtEntity copyWith({
    String? name,
    String? creditor,
    int? initialAmount,
    int? interestRateBp,
    int? minPayment,
    int? dueDay,
    int? priority,
    bool? archived,
    DebtType? debtType,
    bool? hasManagementFee,
    int? managementFee,
    DebtFrequency? frequencyType,
    int? intervalDays,
    DateTime? nextDueDate,
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
      debtType: debtType ?? this.debtType,
      hasManagementFee: hasManagementFee ?? this.hasManagementFee,
      managementFee: managementFee ?? this.managementFee,
      frequencyType: frequencyType ?? this.frequencyType,
      intervalDays: intervalDays ?? this.intervalDays,
      nextDueDate: nextDueDate ?? this.nextDueDate,
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
          archived == other.archived &&
          debtType == other.debtType &&
          hasManagementFee == other.hasManagementFee &&
          managementFee == other.managementFee &&
          frequencyType == other.frequencyType &&
          intervalDays == other.intervalDays &&
          nextDueDate == other.nextDueDate;

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
    debtType,
    hasManagementFee,
    managementFee,
    frequencyType,
    intervalDays,
    nextDueDate,
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

  /// Minimum principal payment required in the current cycle
  int get cyclePrincipalPayment {
    if (currentBalance <= 0) return 0;
    if (debt.minPayment <= 0) return currentBalance;
    return debt.minPayment < currentBalance ? debt.minPayment : currentBalance;
  }

  /// Total obligation for the current payment cycle (principal + management fee if active)
  int get totalCycleObligation {
    if (currentBalance <= 0) return 0;
    return cyclePrincipalPayment + debt.effectiveManagementFee;
  }

  /// Calculates days until next payment relative to [referenceDate].
  /// Negative means overdue; 0 means due today; positive means days remaining.
  int daysUntilDue(DateTime referenceDate) {
    final today = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );
    if (debt.nextDueDate != null) {
      final due = DateTime(
        debt.nextDueDate!.year,
        debt.nextDueDate!.month,
        debt.nextDueDate!.day,
      );
      return due.difference(today).inDays;
    }
    return debt.dueDay - today.day;
  }

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
