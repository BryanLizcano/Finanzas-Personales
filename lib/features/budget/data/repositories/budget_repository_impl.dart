import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/allocation_rule.dart';
import '../../domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final AppDatabase _db;

  BudgetRepositoryImpl(this._db);

  AllocationRule _toEntity(AllocationRulesTableData row) {
    return AllocationRule(
      id: row.id,
      target: AllocationTarget.fromString(row.target),
      percent: row.percent,
    );
  }

  @override
  Future<Result<int, Failure>> getBaseIncome() async {
    try {
      final setting = await (_db.select(
        _db.appSettingsTable,
      )..where((t) => t.key.equals('base_income'))).getSingleOrNull();

      if (setting == null) {
        return const Result.ok(0);
      }

      final parsed = int.tryParse(setting.value) ?? 0;
      return Result.ok(parsed);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> setBaseIncome(int amount) async {
    try {
      await _db
          .into(_db.appSettingsTable)
          .insertOnConflictUpdate(
            AppSettingsTableCompanion.insert(
              key: 'base_income',
              value: amount.toString(),
            ),
          );
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<List<AllocationRule>, Failure>> getAllocationRules() async {
    try {
      final rows = await _db.select(_db.allocationRulesTable).get();
      return Result.ok(rows.map(_toEntity).toList());
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> setAllocationRules({
    required int debtsPercent,
    required int savingsPercent,
    required int freePercent,
  }) async {
    try {
      await _db.transaction(() async {
        await (_db.update(_db.allocationRulesTable)
              ..where((t) => t.target.equals('debts')))
            .write(AllocationRulesTableCompanion(percent: Value(debtsPercent)));

        await (_db.update(
          _db.allocationRulesTable,
        )..where((t) => t.target.equals('savings'))).write(
          AllocationRulesTableCompanion(percent: Value(savingsPercent)),
        );

        await (_db.update(_db.allocationRulesTable)
              ..where((t) => t.target.equals('free')))
            .write(AllocationRulesTableCompanion(percent: Value(freePercent)));
      });

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Stream<int> watchBaseIncome() {
    return (_db.select(_db.appSettingsTable)
          ..where((t) => t.key.equals('base_income')))
        .watchSingleOrNull()
        .map((row) => row == null ? 0 : int.tryParse(row.value) ?? 0);
  }

  @override
  Stream<List<AllocationRule>> watchAllocationRules() {
    return _db
        .select(_db.allocationRulesTable)
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }
}
