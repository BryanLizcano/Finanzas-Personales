import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../repositories/budget_repository.dart';

class SetBaseIncome {
  final BudgetRepository _repository;

  const SetBaseIncome(this._repository);

  Future<Result<void, Failure>> call(int amount) async {
    if (amount < 0) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Base income cannot be negative'),
      );
    }
    return _repository.setBaseIncome(amount);
  }
}
