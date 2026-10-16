import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/debt.dart';
import '../repositories/debt_repository.dart';

class DebtPaymentSuggestion {
  final DebtWithBalance? targetDebt;
  final int suggestedAmount;
  final DebtStrategy strategy;
  final List<DebtWithBalance> rankedDebts;

  const DebtPaymentSuggestion({
    required this.targetDebt,
    required this.suggestedAmount,
    required this.strategy,
    required this.rankedDebts,
  });
}

class SuggestDebtPayment {
  final DebtRepository _repository;

  const SuggestDebtPayment(this._repository);

  Future<Result<DebtPaymentSuggestion, Failure>> call({
    int? availableAmount,
    DebtStrategy? strategyOverride,
  }) async {
    try {
      final strategy =
          strategyOverride ??
          (await _repository.getDebtStrategy()).valueOrNull ??
          DebtStrategy.avalanche;

      final allDebts = await _repository.getDebtsWithBalance(
        includeArchived: false,
      );
      final activeDebts = allDebts.where((d) => d.currentBalance > 0).toList();

      if (activeDebts.isEmpty) {
        return Result.ok(
          DebtPaymentSuggestion(
            targetDebt: null,
            suggestedAmount: 0,
            strategy: strategy,
            rankedDebts: const [],
          ),
        );
      }

      // Sort by strategy (RN-13)
      activeDebts.sort((a, b) {
        if (strategy == DebtStrategy.avalanche) {
          // Highest interest rate first
          final cmp = b.debt.interestRateBp.compareTo(a.debt.interestRateBp);
          if (cmp != 0) return cmp;
          return a.currentBalance.compareTo(b.currentBalance);
        } else {
          // Snowball: lowest balance first
          final cmp = a.currentBalance.compareTo(b.currentBalance);
          if (cmp != 0) return cmp;
          return b.debt.interestRateBp.compareTo(a.debt.interestRateBp);
        }
      });

      final target = activeDebts.first;
      int suggested;
      if (availableAmount != null && availableAmount > 0) {
        suggested = availableAmount > target.currentBalance
            ? target.currentBalance
            : availableAmount;
      } else {
        suggested = target.debt.minPayment > target.currentBalance
            ? target.currentBalance
            : target.debt.minPayment;
      }

      return Result.ok(
        DebtPaymentSuggestion(
          targetDebt: target,
          suggestedAmount: suggested,
          strategy: strategy,
          rankedDebts: activeDebts,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }
}
