import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/debt.dart';
import '../repositories/debt_repository.dart';

class CreateDebt {
  final DebtRepository _repository;

  const CreateDebt(this._repository);

  Future<Result<DebtEntity, Failure>> call({
    required String name,
    required String creditor,
    required int initialAmount,
    required int interestRateBp,
    required int minPayment,
    required int dueDay,
    int priority = 1,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Debt name cannot be empty'),
      );
    }
    if (initialAmount <= 0) {
      return const Result.error(
        Failure(
          FailureCode.invalidAmount,
          'Initial amount must be greater than 0',
        ),
      );
    }
    if (dueDay < 1 || dueDay > 31) {
      return const Result.error(
        Failure(FailureCode.invalidDate, 'Due day must be between 1 and 31'),
      );
    }

    return _repository.createDebt(
      name: trimmedName,
      creditor: creditor.trim(),
      initialAmount: initialAmount,
      interestRateBp: interestRateBp,
      minPayment: minPayment,
      dueDay: dueDay,
      priority: priority,
    );
  }
}
