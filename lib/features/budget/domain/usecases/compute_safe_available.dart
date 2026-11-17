import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../debts/domain/repositories/debt_repository.dart';
import '../entities/allocation_rule.dart';
import '../repositories/budget_repository.dart';

class ComputeSafeAvailable {
  final BudgetRepository budgetRepository;
  final DebtRepository debtRepository;
  final AccountRepository? accountRepository;

  const ComputeSafeAvailable({
    required this.budgetRepository,
    required this.debtRepository,
    this.accountRepository,
  });

  Future<Result<SafeAvailableResult, Failure>> call({
    int fixedExpenses = 0,
    int savingsContribution = 0,
  }) async {
    try {
      final baseIncomeRes = await budgetRepository.getBaseIncome();
      final baseIncome = baseIncomeRes.valueOrNull ?? 0;

      // Sum active debts cycle obligations (principal minPayment + managementFee if active)
      final debts = await debtRepository.getDebtsWithBalance(
        includeArchived: false,
      );
      final activeDebts = debts.where((d) => d.currentBalance > 0).toList();
      final debtMinPayments = activeDebts.fold<int>(
        0,
        (acc, d) => acc + d.totalCycleObligation,
      );
      final totalManagementFees = activeDebts.fold<int>(
        0,
        (acc, d) => acc + d.debt.effectiveManagementFee,
      );

      int liquidBalance = 0;
      bool hasAccounts = false;
      if (accountRepository != null) {
        final accountsList = await accountRepository!
            .watchAccountsWithBalance(includeArchived: false)
            .first;
        hasAccounts = accountsList.isNotEmpty;
        liquidBalance = accountsList
            .where((a) => a.account.type != AccountType.savings)
            .fold<int>(0, (sum, a) => sum + a.balance.units);
      }

      final safeAvailable =
          baseIncome - fixedExpenses - debtMinPayments - savingsContribution;
      final netBalanceAfterDebts =
          liquidBalance - fixedExpenses - debtMinPayments - savingsContribution;

      return Result.ok(
        SafeAvailableResult(
          baseIncome: baseIncome,
          fixedExpenses: fixedExpenses,
          debtMinPayments: debtMinPayments,
          savingsContribution: savingsContribution,
          safeAvailable: safeAvailable,
          isDeficit: safeAvailable < 0,
          liquidBalance: liquidBalance,
          totalManagementFees: totalManagementFees,
          netBalanceAfterDebts: netBalanceAfterDebts,
          hasAccounts: hasAccounts,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }
}
