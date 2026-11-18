import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/debt.dart';
import '../../domain/repositories/debt_repository.dart';

class DebtRepositoryImpl implements DebtRepository {
  final AppDatabase _db;

  DebtRepositoryImpl(this._db);

  DebtEntity _toEntity(DebtsTableData row) {
    return DebtEntity(
      id: row.id,
      name: row.name,
      creditor: row.creditor,
      initialAmount: row.initialAmount,
      interestRateBp: row.interestRateBp,
      minPayment: row.minPayment,
      dueDay: row.dueDay,
      priority: row.priority,
      archived: row.archived,
      debtType: DebtType.fromString(row.debtType),
      hasManagementFee: row.hasManagementFee,
      managementFee: row.managementFee,
      frequencyType: DebtFrequency.fromString(row.frequencyType),
      intervalDays: row.intervalDays,
      nextDueDate: row.nextDueDate,
    );
  }

  Future<int> _calculatePaidAmount(int debtId) async {
    final query = _db.selectOnly(_db.transactionsTable)
      ..addColumns([_db.transactionsTable.amount.sum()])
      ..where(
        _db.transactionsTable.debtId.equals(debtId) &
            _db.transactionsTable.kind.equals('expense') &
            _db.transactionsTable.deletedAt.isNull(),
      );

    final sum =
        await query
            .map((row) => row.read(_db.transactionsTable.amount.sum()))
            .getSingle() ??
        0;
    return sum;
  }

  @override
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
  }) async {
    try {
      final id = await _db
          .into(_db.debtsTable)
          .insert(
            DebtsTableCompanion.insert(
              name: name,
              creditor: creditor,
              initialAmount: initialAmount,
              interestRateBp: interestRateBp,
              minPayment: minPayment,
              dueDay: dueDay,
              priority: priority,
              archived: const Value(false),
              debtType: Value(debtType.dbValue),
              hasManagementFee: Value(hasManagementFee),
              managementFee: Value(managementFee),
              frequencyType: Value(frequencyType.dbValue),
              intervalDays: intervalDays != null
                  ? Value(intervalDays)
                  : const Value.absent(),
              nextDueDate: nextDueDate != null
                  ? Value(nextDueDate)
                  : const Value.absent(),
            ),
          );

      final row = await (_db.select(
        _db.debtsTable,
      )..where((t) => t.id.equals(id))).getSingle();

      return Result.ok(_toEntity(row));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final rows =
          await (_db.update(
            _db.debtsTable,
          )..where((t) => t.id.equals(id))).write(
            DebtsTableCompanion(
              name: name != null ? Value(name) : const Value.absent(),
              creditor: creditor != null
                  ? Value(creditor)
                  : const Value.absent(),
              initialAmount: initialAmount != null
                  ? Value(initialAmount)
                  : const Value.absent(),
              interestRateBp: interestRateBp != null
                  ? Value(interestRateBp)
                  : const Value.absent(),
              minPayment: minPayment != null
                  ? Value(minPayment)
                  : const Value.absent(),
              dueDay: dueDay != null ? Value(dueDay) : const Value.absent(),
              priority: priority != null
                  ? Value(priority)
                  : const Value.absent(),
              debtType: debtType != null
                  ? Value(debtType.dbValue)
                  : const Value.absent(),
              hasManagementFee: hasManagementFee != null
                  ? Value(hasManagementFee)
                  : const Value.absent(),
              managementFee: managementFee != null
                  ? Value(managementFee)
                  : const Value.absent(),
              frequencyType: frequencyType != null
                  ? Value(frequencyType.dbValue)
                  : const Value.absent(),
              intervalDays: intervalDays != null
                  ? Value(intervalDays)
                  : const Value.absent(),
              nextDueDate: nextDueDate != null
                  ? Value(nextDueDate)
                  : const Value.absent(),
            ),
          );

      if (rows == 0) {
        return const Result.error(Failure(FailureCode.debtNotFound));
      }

      final updated = await (_db.select(
        _db.debtsTable,
      )..where((t) => t.id.equals(id))).getSingle();

      return Result.ok(_toEntity(updated));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> archiveDebt({
    required int id,
    required bool archived,
  }) async {
    try {
      final rows =
          await (_db.update(_db.debtsTable)..where((t) => t.id.equals(id)))
              .write(DebtsTableCompanion(archived: Value(archived)));

      if (rows == 0) {
        return const Result.error(Failure(FailureCode.debtNotFound));
      }

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<DebtEntity?, Failure>> getDebtById(int id) async {
    try {
      final row = await (_db.select(
        _db.debtsTable,
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
  Future<Result<DebtWithBalance, Failure>> getDebtWithBalance(int id) async {
    try {
      final row = await (_db.select(
        _db.debtsTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (row == null) {
        return const Result.error(Failure(FailureCode.debtNotFound));
      }

      final paid = await _calculatePaidAmount(id);
      final current = (row.initialAmount - paid).clamp(0, row.initialAmount);

      return Result.ok(
        DebtWithBalance(
          debt: _toEntity(row),
          paidAmount: paid,
          currentBalance: current,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Stream<List<DebtWithBalance>> watchDebtsWithBalance({
    bool includeArchived = false,
  }) async* {
    yield await getDebtsWithBalance(includeArchived: includeArchived);
    await for (final _ in _db.tableUpdates(
      TableUpdateQuery.onAllTables([_db.debtsTable, _db.transactionsTable]),
    )) {
      yield await getDebtsWithBalance(includeArchived: includeArchived);
    }
  }

  @override
  Future<List<DebtWithBalance>> getDebtsWithBalance({
    bool includeArchived = false,
  }) async {
    final query = _db.select(_db.debtsTable);
    if (!includeArchived) {
      query.where((t) => t.archived.equals(false));
    }
    final rows = await query.get();

    final list = <DebtWithBalance>[];
    for (final d in rows) {
      final paid = await _calculatePaidAmount(d.id);
      final current = (d.initialAmount - paid).clamp(0, d.initialAmount);
      list.add(
        DebtWithBalance(
          debt: _toEntity(d),
          paidAmount: paid,
          currentBalance: current,
        ),
      );
    }
    return list;
  }

  @override
  Future<Result<DebtStrategy, Failure>> getDebtStrategy() async {
    try {
      final setting = await (_db.select(
        _db.appSettingsTable,
      )..where((t) => t.key.equals('debt_strategy'))).getSingleOrNull();

      if (setting == null) {
        return const Result.ok(DebtStrategy.avalanche);
      }

      return Result.ok(DebtStrategy.fromString(setting.value));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> setDebtStrategy(DebtStrategy strategy) async {
    try {
      await _db
          .into(_db.appSettingsTable)
          .insertOnConflictUpdate(
            AppSettingsTableCompanion.insert(
              key: 'debt_strategy',
              value: strategy.name,
            ),
          );
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<List<DebtWithBalance>> getUpcomingDueDebts({
    required DateTime referenceDate,
    int daysAhead = 3,
  }) async {
    final active = (await getDebtsWithBalance(includeArchived: false))
        .where((d) => d.currentBalance > 0)
        .toList();

    return active.where((d) {
      final diff = d.daysUntilDue(referenceDate);
      return diff >= 0 && diff <= daysAhead;
    }).toList();
  }
}
