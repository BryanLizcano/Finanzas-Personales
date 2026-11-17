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
    DebtType? debtType,
    bool hasManagementFee = false,
    int managementFee = 0,
    DebtFrequency frequencyType = DebtFrequency.monthly,
    int? intervalDays,
    DateTime? nextDueDate,
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

    int effectiveDueDay = dueDay;
    DateTime? effectiveNextDue = nextDueDate;
    int? effectiveInterval = intervalDays;

    if (frequencyType == DebtFrequency.inDays ||
        frequencyType == DebtFrequency.biweekly) {
      final days =
          effectiveInterval ??
          (frequencyType == DebtFrequency.biweekly ? 15 : 7);
      if (days < 1) {
        return const Result.error(
          Failure(
            FailureCode.invalidDate,
            'Interval days must be at least 1 day',
          ),
        );
      }
      effectiveInterval = days;
      final now = DateTime.now();
      effectiveNextDue ??= DateTime(
        now.year,
        now.month,
        now.day,
      ).add(Duration(days: days));
      effectiveDueDay = effectiveNextDue.day.clamp(1, 31);
    } else {
      if (dueDay < 1 || dueDay > 31) {
        return const Result.error(
          Failure(FailureCode.invalidDate, 'Due day must be between 1 and 31'),
        );
      }
    }

    final resolvedType =
        debtType ??
        ((interestRateBp > 0 || hasManagementFee)
            ? DebtType.creditCard
            : DebtType.personal);

    final effectiveInterest = resolvedType == DebtType.personal
        ? 0
        : (interestRateBp < 0 ? 0 : interestRateBp);
    final effectiveHasFee =
        resolvedType != DebtType.personal && hasManagementFee;
    final effectiveFee = effectiveHasFee && managementFee > 0
        ? managementFee
        : 0;
    final effectiveMinPay = minPayment > 0 ? minPayment : initialAmount;

    return _repository.createDebt(
      name: trimmedName,
      creditor: creditor.trim(),
      initialAmount: initialAmount,
      interestRateBp: effectiveInterest,
      minPayment: effectiveMinPay,
      dueDay: effectiveDueDay,
      priority: priority,
      debtType: resolvedType,
      hasManagementFee: effectiveHasFee,
      managementFee: effectiveFee,
      frequencyType: frequencyType,
      intervalDays: effectiveInterval,
      nextDueDate: effectiveNextDue,
    );
  }
}
