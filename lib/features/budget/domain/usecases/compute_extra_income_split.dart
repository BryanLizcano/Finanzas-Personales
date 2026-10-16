import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/allocation_rule.dart';
import '../repositories/budget_repository.dart';

class ComputeExtraIncomeSplit {
  final BudgetRepository _repository;

  const ComputeExtraIncomeSplit(this._repository);

  Future<Result<ExtraIncomeSplit, Failure>> call({
    required int actualMonthlyIncome,
  }) async {
    try {
      final baseIncomeRes = await _repository.getBaseIncome();
      final baseIncome = baseIncomeRes.valueOrNull ?? 0;

      // RN-07: If actual income < base income, mark deficit and do not suggest split
      if (actualMonthlyIncome < baseIncome) {
        return const Result.ok(
          ExtraIncomeSplit(
            totalExtraIncome: 0,
            debtsAmount: 0,
            savingsAmount: 0,
            freeAmount: 0,
            hasDeficit: true,
          ),
        );
      }

      // RN-06: extra = real - base
      final extraIncome = actualMonthlyIncome - baseIncome;
      if (extraIncome <= 0) {
        return const Result.ok(
          ExtraIncomeSplit(
            totalExtraIncome: 0,
            debtsAmount: 0,
            savingsAmount: 0,
            freeAmount: 0,
            hasDeficit: false,
          ),
        );
      }

      final rulesRes = await _repository.getAllocationRules();
      final rules = rulesRes.valueOrNull ?? [];

      final debtsPercent = rules
          .firstWhere(
            (r) => r.target == AllocationTarget.debts,
            orElse: () => const AllocationRule(
              id: 0,
              target: AllocationTarget.debts,
              percent: 50,
            ),
          )
          .percent;

      final savingsPercent = rules
          .firstWhere(
            (r) => r.target == AllocationTarget.savings,
            orElse: () => const AllocationRule(
              id: 0,
              target: AllocationTarget.savings,
              percent: 20,
            ),
          )
          .percent;

      // Exact integer allocation
      final debtsAmount = (extraIncome * debtsPercent) ~/ 100;
      final savingsAmount = (extraIncome * savingsPercent) ~/ 100;
      final freeAmount = extraIncome - debtsAmount - savingsAmount;

      return Result.ok(
        ExtraIncomeSplit(
          totalExtraIncome: extraIncome,
          debtsAmount: debtsAmount,
          savingsAmount: savingsAmount,
          freeAmount: freeAmount,
          hasDeficit: false,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }
}
