import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/money/currency.dart';
import '../../../../core/money/money.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/account_with_balance.dart';
import '../../domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AppDatabase _db;
  final Currency _currency;

  AccountRepositoryImpl(this._db, [this._currency = Currency.cop]);

  @override
  Future<Result<Account, Failure>> createAccount({
    required String name,
    required AccountType type,
    required int initialBalance,
  }) async {
    try {
      final id = await _db
          .into(_db.accountsTable)
          .insert(
            AccountsTableCompanion.insert(
              name: name,
              type: type.name,
              initialBalance: initialBalance,
            ),
          );
      final account = Account(
        id: id,
        name: name,
        type: type,
        initialBalance: initialBalance,
      );
      return Result.ok(account);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<Account, Failure>> updateAccount({
    required int id,
    required String name,
    required AccountType type,
  }) async {
    try {
      final updatedRows =
          await (_db.update(
            _db.accountsTable,
          )..where((t) => t.id.equals(id))).write(
            AccountsTableCompanion(name: Value(name), type: Value(type.name)),
          );

      if (updatedRows == 0) {
        return const Result.error(Failure(FailureCode.accountNotFound));
      }

      final existing = await (_db.select(
        _db.accountsTable,
      )..where((t) => t.id.equals(id))).getSingle();

      return Result.ok(
        Account(
          id: existing.id,
          name: existing.name,
          type: AccountType.fromString(existing.type),
          initialBalance: existing.initialBalance,
          archived: existing.archived,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> archiveAccount({
    required int id,
    required bool archived,
  }) async {
    try {
      final updatedRows =
          await (_db.update(_db.accountsTable)..where((t) => t.id.equals(id)))
              .write(AccountsTableCompanion(archived: Value(archived)));

      if (updatedRows == 0) {
        return const Result.error(Failure(FailureCode.accountNotFound));
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<Result<Account?, Failure>> getAccountById(int id) async {
    try {
      final row = await (_db.select(
        _db.accountsTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (row == null) {
        return const Result.ok(null);
      }

      return Result.ok(
        Account(
          id: row.id,
          name: row.name,
          type: AccountType.fromString(row.type),
          initialBalance: row.initialBalance,
          archived: row.archived,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Stream<List<AccountWithBalance>> watchAccountsWithBalance({
    bool includeArchived = false,
  }) {
    final accountsQuery = _db.select(_db.accountsTable);
    if (!includeArchived) {
      accountsQuery.where((t) => t.archived.equals(false));
    }

    return accountsQuery.watch().asyncMap((accounts) async {
      final list = <AccountWithBalance>[];
      for (final a in accounts) {
        final balResult = await getAccountBalance(a.id);
        final balance = balResult.isOk
            ? balResult.valueOrNull!
            : Money(units: a.initialBalance, currency: _currency);
        list.add(
          AccountWithBalance(
            account: Account(
              id: a.id,
              name: a.name,
              type: AccountType.fromString(a.type),
              initialBalance: a.initialBalance,
              archived: a.archived,
            ),
            balance: balance,
          ),
        );
      }
      return list;
    });
  }

  @override
  Future<Result<Money, Failure>> getAccountBalance(int accountId) async {
    try {
      final accountRow = await (_db.select(
        _db.accountsTable,
      )..where((t) => t.id.equals(accountId))).getSingleOrNull();

      if (accountRow == null) {
        return const Result.error(Failure(FailureCode.accountNotFound));
      }

      // Initial balance
      var total = accountRow.initialBalance;

      // Incomes where this account is source: +amount
      final incomeQuery = _db.selectOnly(_db.transactionsTable)
        ..addColumns([_db.transactionsTable.amount.sum()])
        ..where(
          _db.transactionsTable.accountId.equals(accountId) &
              _db.transactionsTable.kind.equals('income') &
              _db.transactionsTable.deletedAt.isNull(),
        );
      final incomeSum =
          await incomeQuery
              .map((row) => row.read(_db.transactionsTable.amount.sum()))
              .getSingle() ??
          0;
      total += incomeSum;

      // Expenses where this account is source: -amount
      final expenseQuery = _db.selectOnly(_db.transactionsTable)
        ..addColumns([_db.transactionsTable.amount.sum()])
        ..where(
          _db.transactionsTable.accountId.equals(accountId) &
              _db.transactionsTable.kind.equals('expense') &
              _db.transactionsTable.deletedAt.isNull(),
        );
      final expenseSum =
          await expenseQuery
              .map((row) => row.read(_db.transactionsTable.amount.sum()))
              .getSingle() ??
          0;
      total -= expenseSum;

      // Outgoing transfers: -amount
      final transferOutQuery = _db.selectOnly(_db.transactionsTable)
        ..addColumns([_db.transactionsTable.amount.sum()])
        ..where(
          _db.transactionsTable.accountId.equals(accountId) &
              _db.transactionsTable.kind.equals('transfer') &
              _db.transactionsTable.deletedAt.isNull(),
        );
      final transferOutSum =
          await transferOutQuery
              .map((row) => row.read(_db.transactionsTable.amount.sum()))
              .getSingle() ??
          0;
      total -= transferOutSum;

      // Incoming transfers: +amount
      final transferInQuery = _db.selectOnly(_db.transactionsTable)
        ..addColumns([_db.transactionsTable.amount.sum()])
        ..where(
          _db.transactionsTable.toAccountId.equals(accountId) &
              _db.transactionsTable.kind.equals('transfer') &
              _db.transactionsTable.deletedAt.isNull(),
        );
      final transferInSum =
          await transferInQuery
              .map((row) => row.read(_db.transactionsTable.amount.sum()))
              .getSingle() ??
          0;
      total += transferInSum;

      return Result.ok(Money(units: total, currency: _currency));
    } catch (e) {
      return Result.error(Failure(FailureCode.databaseError, e.toString()));
    }
  }

  @override
  Future<bool> hasTransactions(int accountId) async {
    final query = _db.select(_db.transactionsTable)
      ..where(
        (t) =>
            (t.accountId.equals(accountId) | t.toAccountId.equals(accountId)) &
            t.deletedAt.isNull(),
      )
      ..limit(1);
    final count = await query.get();
    return count.isNotEmpty;
  }
}
