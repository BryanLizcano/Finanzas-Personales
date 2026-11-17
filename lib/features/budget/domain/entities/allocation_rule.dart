enum AllocationTarget {
  debts,
  savings,
  free;

  static AllocationTarget fromString(String val) {
    switch (val.toLowerCase()) {
      case 'debts':
        return AllocationTarget.debts;
      case 'savings':
        return AllocationTarget.savings;
      case 'free':
      default:
        return AllocationTarget.free;
    }
  }
}

class AllocationRule {
  final int id;
  final AllocationTarget target;
  final int percent;

  const AllocationRule({
    required this.id,
    required this.target,
    required this.percent,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllocationRule &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          target == other.target &&
          percent == other.percent;

  @override
  int get hashCode => Object.hash(id, target, percent);
}

class ExtraIncomeSplit {
  final int totalExtraIncome;
  final int debtsAmount;
  final int savingsAmount;
  final int freeAmount;
  final bool hasDeficit;

  const ExtraIncomeSplit({
    required this.totalExtraIncome,
    required this.debtsAmount,
    required this.savingsAmount,
    required this.freeAmount,
    this.hasDeficit = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtraIncomeSplit &&
          runtimeType == other.runtimeType &&
          totalExtraIncome == other.totalExtraIncome &&
          debtsAmount == other.debtsAmount &&
          savingsAmount == other.savingsAmount &&
          freeAmount == other.freeAmount &&
          hasDeficit == other.hasDeficit;

  @override
  int get hashCode => Object.hash(
    totalExtraIncome,
    debtsAmount,
    savingsAmount,
    freeAmount,
    hasDeficit,
  );
}

class SafeAvailableResult {
  final int baseIncome;
  final int fixedExpenses;
  final int debtMinPayments;
  final int savingsContribution;
  final int safeAvailable;
  final bool isDeficit;
  final int liquidBalance;
  final int totalManagementFees;
  final int netBalanceAfterDebts;
  final bool hasAccounts;

  const SafeAvailableResult({
    required this.baseIncome,
    required this.fixedExpenses,
    required this.debtMinPayments,
    required this.savingsContribution,
    required this.safeAvailable,
    required this.isDeficit,
    this.liquidBalance = 0,
    this.totalManagementFees = 0,
    this.netBalanceAfterDebts = 0,
    this.hasAccounts = false,
  });

  /// Real-time shortfall: how much more money the user needs to earn to cover pending debt obligations.
  int get shortfallForDebts {
    if (hasAccounts) {
      return netBalanceAfterDebts < 0 ? -netBalanceAfterDebts : 0;
    }
    return safeAvailable < 0 ? -safeAvailable : 0;
  }

  /// Real-time surplus: how much money is left free after setting aside all pending debt payments.
  int get surplusAfterDebts {
    if (hasAccounts) {
      return netBalanceAfterDebts > 0 ? netBalanceAfterDebts : 0;
    }
    return safeAvailable > 0 ? safeAvailable : 0;
  }

  /// Effective available amount to display in real-time (reacts to expenses, daily earnings, and debt payments).
  int get effectiveAvailable =>
      hasAccounts ? netBalanceAfterDebts : safeAvailable;

  bool get isEffectiveDeficit => effectiveAvailable < 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SafeAvailableResult &&
          runtimeType == other.runtimeType &&
          baseIncome == other.baseIncome &&
          fixedExpenses == other.fixedExpenses &&
          debtMinPayments == other.debtMinPayments &&
          savingsContribution == other.savingsContribution &&
          safeAvailable == other.safeAvailable &&
          isDeficit == other.isDeficit &&
          liquidBalance == other.liquidBalance &&
          totalManagementFees == other.totalManagementFees &&
          netBalanceAfterDebts == other.netBalanceAfterDebts &&
          hasAccounts == other.hasAccounts;

  @override
  int get hashCode => Object.hash(
    baseIncome,
    fixedExpenses,
    debtMinPayments,
    savingsContribution,
    safeAvailable,
    isDeficit,
    liquidBalance,
    totalManagementFees,
    netBalanceAfterDebts,
    hasAccounts,
  );
}
