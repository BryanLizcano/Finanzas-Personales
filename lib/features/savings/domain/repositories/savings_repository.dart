import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/savings_goal.dart';

abstract class SavingsRepository {
  Future<Result<SavingsGoalEntity, Failure>> createGoal({
    required String name,
    required int targetAmount,
    DateTime? targetDate,
  });

  Future<Result<SavingsGoalEntity, Failure>> updateGoal({
    required int id,
    String? name,
    int? targetAmount,
    DateTime? targetDate,
  });

  Future<Result<void, Failure>> archiveGoal({
    required int id,
    required bool archived,
  });

  Future<Result<SavingsGoalEntity?, Failure>> getGoalById(int id);

  Future<Result<SavingsGoalWithProgress, Failure>> getGoalWithProgress(int id);

  Stream<List<SavingsGoalWithProgress>> watchGoalsWithProgress({
    bool includeArchived = false,
  });

  Future<List<SavingsGoalWithProgress>> getGoalsWithProgress({
    bool includeArchived = false,
  });

  Future<int> getTotalSavedAmount();
}
