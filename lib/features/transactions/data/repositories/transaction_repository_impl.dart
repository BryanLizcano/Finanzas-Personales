import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase _db;

  TransactionRepositoryImpl(this._db);

  TransactionEntity _toEntity(TransactionsTableData row) {
    return TransactionEntity(
      id: row.id,
      kind: TransactionKind.fromString(row.kind),
      amount: row.amount,
      accountId: row.accountId,
      toAccountId: row.toAccountId,
      categoryId: row.categoryId,
      debtId: row.debtId,
      receivableId: row.receivableId,
      goalId: row.goalId,
      occurredAt: row.occurredAt,
      note: row.note,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  @override
  Future<Result<TransactionEntity, Failure>> addTransaction({
    required TransactionKind kind,
    required int amount,
    required int accountId,
    int? toAccountId,
    int? categoryId,
    int? debtId,
    int? receivableId,
    int? goalId,
    required DateTime occurredAt,
    String note = '',
  }) async {
    try {
      final now = DateTime.now();
      final id = await _db
          .into(_db.transactionsTable)
          .insert(
            TransactionsTableCompanion.insert(
              kind: kind.name,
              amount: amount,
              accountId: accountId,
              toAccountId: toAccountId != null
                  ? Value(toAccountId)
                  : const Value.absent(),
              categoryId: categoryId != null
                  ? Value(categoryId)
                  : const Value.absent(),
              debtId: debtId != null ? Value(debtId) : const Value.absent(),
              receivableId: receivableId != null
                  ? Value(receivableId)
                  : const Value.absent(),
              goalId: goalId != null ? Value(goalId) : const Value.absent(),
              occurredAt: occurredAt,
              note: Value(note),
              createdAt: now,
              updatedAt: now,
            ),
          );

      final row = await (_db.select(
        _db.transactionsTable,
      )..where((t) => t.id.equals(id))).getSingle();

      return Result.ok(_toEntity(row));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<TransactionEntity, Failure>> updateTransaction({
    required int id,
    int? amount,
    int? accountId,
    int? toAccountId,
    int? categoryId,
    int? debtId,
    int? receivableId,
    int? goalId,
    DateTime? occurredAt,
    String? note,
  }) async {
    try {
      final existing = await (_db.select(
        _db.transactionsTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (existing == null) {
        return const Result.error(Failure(FailureCode.notFound));
      }

      final now = DateTime.now();
      await (_db.update(
        _db.transactionsTable,
      )..where((t) => t.id.equals(id))).write(
        TransactionsTableCompanion(
          amount: amount != null ? Value(amount) : const Value.absent(),
          accountId: accountId != null
              ? Value(accountId)
              : const Value.absent(),
          toAccountId: toAccountId != null
              ? Value(toAccountId)
              : const Value.absent(),
          categoryId: categoryId != null
              ? Value(categoryId)
              : const Value.absent(),
          debtId: debtId != null ? Value(debtId) : const Value.absent(),
          receivableId: receivableId != null
              ? Value(receivableId)
              : const Value.absent(),
          goalId: goalId != null ? Value(goalId) : const Value.absent(),
          occurredAt: occurredAt != null
              ? Value(occurredAt)
              : const Value.absent(),
          note: note != null ? Value(note) : const Value.absent(),
          updatedAt: Value(now),
        ),
      );

      final updated = await (_db.select(
        _db.transactionsTable,
      )..where((t) => t.id.equals(id))).getSingle();

      return Result.ok(_toEntity(updated));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> deleteTransaction(int id) async {
    try {
      final rows =
          await (_db.update(
            _db.transactionsTable,
          )..where((t) => t.id.equals(id))).write(
            TransactionsTableCompanion(
              deletedAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
            ),
          );

      if (rows == 0) {
        return const Result.error(Failure(FailureCode.notFound));
      }

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<TransactionEntity, Failure>> restoreTransaction(int id) async {
    try {
      final rows =
          await (_db.update(
            _db.transactionsTable,
          )..where((t) => t.id.equals(id))).write(
            TransactionsTableCompanion(
              deletedAt: const Value(null),
              updatedAt: Value(DateTime.now()),
            ),
          );

      if (rows == 0) {
        return const Result.error(Failure(FailureCode.notFound));
      }

      final restored = await (_db.select(
        _db.transactionsTable,
      )..where((t) => t.id.equals(id))).getSingle();

      return Result.ok(_toEntity(restored));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<TransactionEntity?, Failure>> getTransactionById(int id) async {
    try {
      final row = await (_db.select(
        _db.transactionsTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (row == null) {
        return const Result.ok(null);
      }

      return Result.ok(_toEntity(row));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  SimpleSelectStatement<$TransactionsTableTable, TransactionsTableData>
  _buildQuery([TransactionFilter? filter]) {
    final query = _db.select(_db.transactionsTable);

    if (filter != null) {
      if (!filter.includeDeleted) {
        query.where((t) => t.deletedAt.isNull());
      }
      if (filter.startDate != null) {
        query.where(
          (t) => t.occurredAt.isBiggerOrEqualValue(filter.startDate!),
        );
      }
      if (filter.endDate != null) {
        query.where((t) => t.occurredAt.isSmallerOrEqualValue(filter.endDate!));
      }
      if (filter.accountId != null) {
        query.where(
          (t) =>
              t.accountId.equals(filter.accountId!) |
              t.toAccountId.equals(filter.accountId!),
        );
      }
      if (filter.categoryId != null) {
        query.where((t) => t.categoryId.equals(filter.categoryId!));
      }
      if (filter.kind != null) {
        query.where((t) => t.kind.equals(filter.kind!.name));
      }
      if (filter.searchQuery != null && filter.searchQuery!.trim().isNotEmpty) {
        query.where((t) => t.note.contains(filter.searchQuery!.trim()));
      }
    } else {
      query.where((t) => t.deletedAt.isNull());
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.occurredAt, mode: OrderingMode.desc),
      (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
    ]);

    return query;
  }

  @override
  Stream<List<TransactionEntity>> watchTransactions([
    TransactionFilter? filter,
  ]) {
    return _buildQuery(filter)
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<List<TransactionEntity>> getTransactions([
    TransactionFilter? filter,
  ]) async {
    final rows = await _buildQuery(filter).get();
    return rows.map(_toEntity).toList();
  }
}
