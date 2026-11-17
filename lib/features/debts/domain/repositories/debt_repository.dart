import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/debt.dart';

abstract class DebtRepository {
  Future<Result<DebtEntity, Failure>> createDebt({
    required String name,
    required String creditor,
    required int initialAmount,
    required int interestRateBp,
    required int minPayment,
    required int dueDay,
    int priority = 1,
    DebtType debtType = DebtType.personal,
    bool hasManagementFee = false,
    int managementFee = 0,
    DebtFrequency frequencyType = DebtFrequency.monthly,
    int? intervalDays,
    DateTime? nextDueDate,
  });

  Future<Result<DebtEntity, Failure>> updateDebt({
    required int id,
    String? name,
    String? creditor,
    int? initialAmount,
    int? interestRateBp,
    int? minPayment,
    int? dueDay,
    int? priority,
    DebtType? debtType,
    bool? hasManagementFee,
    int? managementFee,
    DebtFrequency? frequencyType,
    int? intervalDays,
    DateTime? nextDueDate,
  });

  Future<Result<void, Failure>> archiveDebt({
    required int id,
    required bool archived,
  });

  Future<Result<DebtEntity?, Failure>> getDebtById(int id);

  Future<Result<DebtWithBalance, Failure>> getDebtWithBalance(int id);

  Stream<List<DebtWithBalance>> watchDebtsWithBalance({
    bool includeArchived = false,
  });

  Future<List<DebtWithBalance>> getDebtsWithBalance({
    bool includeArchived = false,
  });

  Future<Result<DebtStrategy, Failure>> getDebtStrategy();

  Future<Result<void, Failure>> setDebtStrategy(DebtStrategy strategy);

  Future<List<DebtWithBalance>> getUpcomingDueDebts({
    required DateTime referenceDate,
    int daysAhead = 3,
  });
}
