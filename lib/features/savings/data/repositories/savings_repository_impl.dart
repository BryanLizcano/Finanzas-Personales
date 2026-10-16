import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/repositories/savings_repository.dart';

class SavingsRepositoryImpl implements SavingsRepository {
  final AppDatabase _db;

  SavingsRepositoryImpl(this._db);

  SavingsGoalEntity _toEntity(SavingsGoalsTableData row) {
    return SavingsGoalEntity(
      id: row.id,
      name: row.name,
      targetAmount: row.targetAmount,
      targetDate: row.targetDate,
      archived: row.archived,
    );
  }

  Future<int> _calculateGoalProgress(int goalId) async {
    // RN-26: Contributions to the goal (transfers where goal_id is set)
    final incomingQuery = _db.selectOnly(_db.transactionsTable)
      ..addColumns([_db.transactionsTable.amount.sum()])
      ..where(
        _db.transactionsTable.goalId.equals(goalId) &
            _db.transactionsTable.toAccountId.isNotNull() &
            _db.transactionsTable.deletedAt.isNull(),
      );

    final incoming =
        await incomingQuery
            .map((row) => row.read(_db.transactionsTable.amount.sum()))
            .getSingle() ??
        0;

    return incoming;
  }

  @override
  Future<Result<SavingsGoalEntity, Failure>> createGoal({
    required String name,
    required int targetAmount,
    DateTime? targetDate,
  }) async {
    try {
      final id = await _db
          .into(_db.savingsGoalsTable)
          .insert(
            SavingsGoalsTableCompanion.insert(
              name: name,
              targetAmount: targetAmount,
              targetDate: targetDate != null
                  ? Value(targetDate)
                  : const Value.absent(),
              archived: const Value(false),
            ),
          );

      final row = await (_db.select(
        _db.savingsGoalsTable,
      )..where((t) => t.id.equals(id))).getSingle();

      return Result.ok(_toEntity(row));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<SavingsGoalEntity, Failure>> updateGoal({
    required int id,
    String? name,
    int? targetAmount,
    DateTime? targetDate,
  }) async {
    try {
      final rows =
          await (_db.update(
            _db.savingsGoalsTable,
          )..where((t) => t.id.equals(id))).write(
            SavingsGoalsTableCompanion(
              name: name != null ? Value(name) : const Value.absent(),
              targetAmount: targetAmount != null
                  ? Value(targetAmount)
                  : const Value.absent(),
              targetDate: targetDate != null
                  ? Value(targetDate)
                  : const Value.absent(),
            ),
          );

      if (rows == 0) {
        return const Result.error(Failure(FailureCode.savingsGoalNotFound));
      }

      final updated = await (_db.select(
        _db.savingsGoalsTable,
      )..where((t) => t.id.equals(id))).getSingle();

      return Result.ok(_toEntity(updated));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> archiveGoal({
    required int id,
    required bool archived,
  }) async {
    try {
      final rows =
          await (_db.update(_db.savingsGoalsTable)
                ..where((t) => t.id.equals(id)))
              .write(SavingsGoalsTableCompanion(archived: Value(archived)));

      if (rows == 0) {
        return const Result.error(Failure(FailureCode.savingsGoalNotFound));
      }

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<SavingsGoalEntity?, Failure>> getGoalById(int id) async {
    try {
      final row = await (_db.select(
        _db.savingsGoalsTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (row == null) {
        return const Result.ok(null);
      }

      return Result.ok(_toEntity(row));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<SavingsGoalWithProgress, Failure>> getGoalWithProgress(
    int id,
  ) async {
    try {
      final row = await (_db.select(
        _db.savingsGoalsTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (row == null) {
        return const Result.error(Failure(FailureCode.savingsGoalNotFound));
      }

      final current = await _calculateGoalProgress(id);
      final ratio = row.targetAmount == 0
          ? 1.0
          : (current / row.targetAmount).clamp(0.0, 1.0);

      return Result.ok(
        SavingsGoalWithProgress(
          goal: _toEntity(row),
          currentAmount: current,
          progressRatio: ratio,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Stream<List<SavingsGoalWithProgress>> watchGoalsWithProgress({
    bool includeArchived = false,
  }) {
    final query = _db.select(_db.savingsGoalsTable);
    if (!includeArchived) {
      query.where((t) => t.archived.equals(false));
    }

    return query.watch().asyncMap((rows) async {
      final list = <SavingsGoalWithProgress>[];
      for (final r in rows) {
        final current = await _calculateGoalProgress(r.id);
        final ratio = r.targetAmount == 0
            ? 1.0
            : (current / r.targetAmount).clamp(0.0, 1.0);
        list.add(
          SavingsGoalWithProgress(
            goal: _toEntity(r),
            currentAmount: current,
            progressRatio: ratio,
          ),
        );
      }
      return list;
    });
  }

  @override
  Future<List<SavingsGoalWithProgress>> getGoalsWithProgress({
    bool includeArchived = false,
  }) async {
    final query = _db.select(_db.savingsGoalsTable);
    if (!includeArchived) {
      query.where((t) => t.archived.equals(false));
    }
    final rows = await query.get();

    final list = <SavingsGoalWithProgress>[];
    for (final r in rows) {
      final current = await _calculateGoalProgress(r.id);
      final ratio = r.targetAmount == 0
          ? 1.0
          : (current / r.targetAmount).clamp(0.0, 1.0);
      list.add(
        SavingsGoalWithProgress(
          goal: _toEntity(r),
          currentAmount: current,
          progressRatio: ratio,
        ),
      );
    }
    return list;
  }

  @override
  Future<int> getTotalSavedAmount() async {
    final list = await getGoalsWithProgress(includeArchived: false);
    return list.fold<int>(0, (acc, item) => acc + item.currentAmount);
  }
}
