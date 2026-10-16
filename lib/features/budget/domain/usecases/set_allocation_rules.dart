import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../repositories/budget_repository.dart';

class SetAllocationRules {
  final BudgetRepository _repository;

  const SetAllocationRules(this._repository);

  Future<Result<void, Failure>> call({
    required int debtsPercent,
    required int savingsPercent,
    required int freePercent,
  }) async {
    // RN-09: Must sum to 100%
    if (debtsPercent < 0 || savingsPercent < 0 || freePercent < 0) {
      return const Result.error(
        Failure(
          FailureCode.invalidAllocationRulePercentSum,
          'Percentages cannot be negative',
        ),
      );
    }

    if (debtsPercent + savingsPercent + freePercent != 100) {
      return const Result.error(
        Failure(
          FailureCode.invalidAllocationRulePercentSum,
          'Allocation rule percentages must sum exactly to 100%',
        ),
      );
    }

    return _repository.setAllocationRules(
      debtsPercent: debtsPercent,
      savingsPercent: savingsPercent,
      freePercent: freePercent,
    );
  }
}
