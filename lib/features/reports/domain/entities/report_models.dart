class MonthlySummary {
  final int year;
  final int month;
  final int totalIncome;
  final int totalExpense;
  final int balance;
  final int totalDebtBalance;
  final int totalReceivableBalance;
  final int totalSaved;
  final int baseIncome;
  final int safeAvailable;

  const MonthlySummary({
    required this.year,
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.totalDebtBalance,
    required this.totalReceivableBalance,
    required this.totalSaved,
    required this.baseIncome,
    required this.safeAvailable,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlySummary &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month &&
          totalIncome == other.totalIncome &&
          totalExpense == other.totalExpense &&
          balance == other.balance &&
          totalDebtBalance == other.totalDebtBalance &&
          totalReceivableBalance == other.totalReceivableBalance &&
          totalSaved == other.totalSaved &&
          baseIncome == other.baseIncome &&
          safeAvailable == other.safeAvailable;

  @override
  int get hashCode => Object.hash(
    year,
    month,
    totalIncome,
    totalExpense,
    balance,
    totalDebtBalance,
    totalReceivableBalance,
    totalSaved,
    baseIncome,
    safeAvailable,
  );
}

class CategoryBreakdownItem {
  final int categoryId;
  final String categoryKeyOrName;
  final String icon;
  final int color;
  final int totalAmount;
  final double percentage;

  const CategoryBreakdownItem({
    required this.categoryId,
    required this.categoryKeyOrName,
    required this.icon,
    required this.color,
    required this.totalAmount,
    required this.percentage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryBreakdownItem &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          categoryKeyOrName == other.categoryKeyOrName &&
          icon == other.icon &&
          color == other.color &&
          totalAmount == other.totalAmount &&
          percentage == other.percentage;

  @override
  int get hashCode => Object.hash(
    categoryId,
    categoryKeyOrName,
    icon,
    color,
    totalAmount,
    percentage,
  );
}

class MonthlyTotalItem {
  final int year;
  final int month;
  final int totalIncome;
  final int totalExpense;

  const MonthlyTotalItem({
    required this.year,
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyTotalItem &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month &&
          totalIncome == other.totalIncome &&
          totalExpense == other.totalExpense;

  @override
  int get hashCode => Object.hash(year, month, totalIncome, totalExpense);
}

class GroupedExpenseReport {
  final String groupName;
  final List<String> categoryKeys;
  final int totalAmount;

  const GroupedExpenseReport({
    required this.groupName,
    required this.categoryKeys,
    required this.totalAmount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupedExpenseReport &&
          runtimeType == other.runtimeType &&
          groupName == other.groupName &&
          totalAmount == other.totalAmount;

  @override
  int get hashCode => Object.hash(groupName, totalAmount);
}

class ReminderEntity {
  final int id;
  final String title;
  final DateTime dueAt;
  final String? repeatRule;
  final bool done;

  const ReminderEntity({
    required this.id,
    required this.title,
    required this.dueAt,
    this.repeatRule,
    this.done = false,
  });
}
