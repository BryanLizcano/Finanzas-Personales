import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/allocation_rule.dart';

abstract class BudgetRepository {
  Future<Result<int, Failure>> getBaseIncome();

  Future<Result<void, Failure>> setBaseIncome(int amount);

  Future<Result<List<AllocationRule>, Failure>> getAllocationRules();

  Future<Result<void, Failure>> setAllocationRules({
    required int debtsPercent,
    required int savingsPercent,
    required int freePercent,
  });

  Stream<int> watchBaseIncome();

  Stream<List<AllocationRule>> watchAllocationRules();
}
