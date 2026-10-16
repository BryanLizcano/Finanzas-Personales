import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../debts/domain/repositories/debt_repository.dart';
import '../entities/allocation_rule.dart';
import '../repositories/budget_repository.dart';

class ComputeSafeAvailable {
  final BudgetRepository budgetRepository;
  final DebtRepository debtRepository;

  const ComputeSafeAvailable({
    required this.budgetRepository,
    required this.debtRepository,
  });

  Future<Result<SafeAvailableResult, Failure>> call({
    int fixedExpenses = 0,
    int savingsContribution = 0,
  }) async {
    try {
      final baseIncomeRes = await budgetRepository.getBaseIncome();
      final baseIncome = baseIncomeRes.valueOrNull ?? 0;

      // Sum active debts minimum payments
      final debts = await debtRepository.getDebtsWithBalance(
        includeArchived: false,
      );
      final activeDebts = debts.where((d) => d.currentBalance > 0);
      final debtMinPayments = activeDebts.fold<int>(
        0,
        (acc, d) => acc + d.debt.minPayment,
      );

      final safeAvailable =
          baseIncome - fixedExpenses - debtMinPayments - savingsContribution;

      return Result.ok(
        SafeAvailableResult(
          baseIncome: baseIncome,
          fixedExpenses: fixedExpenses,
          debtMinPayments: debtMinPayments,
          savingsContribution: savingsContribution,
          safeAvailable: safeAvailable,
          isDeficit: safeAvailable < 0,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }
}
