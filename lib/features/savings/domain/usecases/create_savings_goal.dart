import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/savings_goal.dart';
import '../repositories/savings_repository.dart';

class CreateSavingsGoal {
  final SavingsRepository _repository;

  const CreateSavingsGoal(this._repository);

  Future<Result<SavingsGoalEntity, Failure>> call({
    required String name,
    required int targetAmount,
    DateTime? targetDate,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Goal name cannot be empty'),
      );
    }
    if (targetAmount <= 0) {
      return const Result.error(
        Failure(
          FailureCode.invalidAmount,
          'Target amount must be greater than 0',
        ),
      );
    }

    return _repository.createGoal(
      name: trimmedName,
      targetAmount: targetAmount,
      targetDate: targetDate,
    );
  }
}
