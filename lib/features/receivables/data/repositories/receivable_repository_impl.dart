import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/receivable.dart';
import '../../domain/repositories/receivable_repository.dart';

class ReceivableRepositoryImpl implements ReceivableRepository {
  final AppDatabase _db;

  ReceivableRepositoryImpl(this._db);

  ReceivableEntity _toEntity(ReceivablesTableData row) {
    return ReceivableEntity(
      id: row.id,
      person: row.person,
      initialAmount: row.initialAmount,
      createdAt: row.createdAt,
      note: row.note,
      archived: row.archived,
    );
  }

  Future<int> _calculateCollectedAmount(int receivableId) async {
    final query = _db.selectOnly(_db.transactionsTable)
      ..addColumns([_db.transactionsTable.amount.sum()])
      ..where(
        _db.transactionsTable.receivableId.equals(receivableId) &
            _db.transactionsTable.kind.equals('income') &
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
  Future<Result<ReceivableEntity, Failure>> createReceivable({
    required String person,
    required int initialAmount,
    required DateTime createdAt,
    String note = '',
  }) async {
    try {
      final id = await _db
          .into(_db.receivablesTable)
          .insert(
            ReceivablesTableCompanion.insert(
              person: person,
              initialAmount: initialAmount,
              createdAt: createdAt,
              note: Value(note),
              archived: const Value(false),
            ),
          );

      final row = await (_db.select(
        _db.receivablesTable,
      )..where((t) => t.id.equals(id))).getSingle();

      return Result.ok(_toEntity(row));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> archiveReceivable({
    required int id,
    required bool archived,
  }) async {
    try {
      final rows =
          await (_db.update(_db.receivablesTable)
                ..where((t) => t.id.equals(id)))
              .write(ReceivablesTableCompanion(archived: Value(archived)));

      if (rows == 0) {
        return const Result.error(Failure(FailureCode.receivableNotFound));
      }

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<ReceivableEntity?, Failure>> getReceivableById(int id) async {
    try {
      final row = await (_db.select(
        _db.receivablesTable,
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
  Future<Result<ReceivableWithBalance, Failure>> getReceivableWithBalance(
    int id,
  ) async {
    try {
      final row = await (_db.select(
        _db.receivablesTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (row == null) {
        return const Result.error(Failure(FailureCode.receivableNotFound));
      }

      final collected = await _calculateCollectedAmount(id);
      final pending = (row.initialAmount - collected).clamp(
        0,
        row.initialAmount,
      );

      return Result.ok(
        ReceivableWithBalance(
          receivable: _toEntity(row),
          collectedAmount: collected,
          pendingBalance: pending,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Stream<List<ReceivableWithBalance>> watchReceivablesWithBalance({
    bool includeArchived = false,
  }) {
    final query = _db.select(_db.receivablesTable);
    if (!includeArchived) {
      query.where((t) => t.archived.equals(false));
    }

    return query.watch().asyncMap((rows) async {
      final list = <ReceivableWithBalance>[];
      for (final r in rows) {
        final collected = await _calculateCollectedAmount(r.id);
        final pending = (r.initialAmount - collected).clamp(0, r.initialAmount);
        list.add(
          ReceivableWithBalance(
            receivable: _toEntity(r),
            collectedAmount: collected,
            pendingBalance: pending,
          ),
        );
      }
      return list;
    });
  }

  @override
  Future<List<ReceivableWithBalance>> getReceivablesWithBalance({
    bool includeArchived = false,
  }) async {
    final query = _db.select(_db.receivablesTable);
    if (!includeArchived) {
      query.where((t) => t.archived.equals(false));
    }
    final rows = await query.get();

    final list = <ReceivableWithBalance>[];
    for (final r in rows) {
      final collected = await _calculateCollectedAmount(r.id);
      final pending = (r.initialAmount - collected).clamp(0, r.initialAmount);
      list.add(
        ReceivableWithBalance(
          receivable: _toEntity(r),
          collectedAmount: collected,
          pendingBalance: pending,
        ),
      );
    }
    return list;
  }

  @override
  Future<int> getTotalPendingReceivable() async {
    final list = await getReceivablesWithBalance(includeArchived: false);
    return list.fold<int>(0, (acc, item) => acc + item.pendingBalance);
  }
}
