import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:finanzas_personales/features/transactions/domain/usecases/add_transaction.dart';
import 'package:finanzas_personales/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:finanzas_personales/features/transactions/domain/usecases/restore_transaction.dart';
import 'package:finanzas_personales/features/transactions/domain/usecases/transfer_between_accounts.dart';
import 'package:finanzas_personales/features/transactions/domain/usecases/update_transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TransactionRepositoryImpl repository;
  late AccountRepositoryImpl accountRepository;
  late AddTransaction addTransaction;
  late UpdateTransaction updateTransaction;
  late DeleteTransaction deleteTransaction;
  late RestoreTransaction restoreTransaction;
  late TransferBetweenAccounts transferBetweenAccounts;

  late int acc1Id;
  late int acc2Id;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = TransactionRepositoryImpl(db);
    accountRepository = AccountRepositoryImpl(db);

    addTransaction = AddTransaction(repository);
    updateTransaction = UpdateTransaction(repository);
    deleteTransaction = DeleteTransaction(repository);
    restoreTransaction = RestoreTransaction(repository);
    transferBetweenAccounts = TransferBetweenAccounts(repository);

    final a1 = (await accountRepository.createAccount(
      name: 'Efectivo',
      type: AccountType.cash,
      initialBalance: 100000,
    )).valueOrNull!;
    acc1Id = a1.id;

    final a2 = (await accountRepository.createAccount(
      name: 'Banco',
      type: AccountType.bank,
      initialBalance: 50000,
    )).valueOrNull!;
    acc2Id = a2.id;
  });

  tearDown(() async {
    await db.close();
  });

  group('Transactions Integrity Rules (T-020)', () {
    test('amount <= 0 fails with invalidAmount', () async {
      final res = await addTransaction(
        kind: TransactionKind.expense,
        amount: 0,
        accountId: acc1Id,
        occurredAt: DateTime.now(),
      );
      expect(res.isError, isTrue);
      expect(res.errorOrNull!.code, FailureCode.invalidAmount);
    });

    test('transfer with same account fails', () async {
      final res = await addTransaction(
        kind: TransactionKind.transfer,
        amount: 5000,
        accountId: acc1Id,
        toAccountId: acc1Id,
        occurredAt: DateTime.now(),
      );
      expect(res.isError, isTrue);
      expect(res.errorOrNull!.code, FailureCode.invalidTransferSameAccount);
    });

    test('transfer with category fails', () async {
      final res = await addTransaction(
        kind: TransactionKind.transfer,
        amount: 5000,
        accountId: acc1Id,
        toAccountId: acc2Id,
        categoryId: 1,
        occurredAt: DateTime.now(),
      );
      expect(res.isError, isTrue);
      expect(res.errorOrNull!.code, FailureCode.invalidTransferSameAccount);
    });

    test('debt_id in income fails', () async {
      final res = await addTransaction(
        kind: TransactionKind.income,
        amount: 5000,
        accountId: acc1Id,
        debtId: 1,
        occurredAt: DateTime.now(),
      );
      expect(res.isError, isTrue);
      expect(res.errorOrNull!.code, FailureCode.invalidAmount);
    });

    test('receivable_id in expense fails', () async {
      final res = await addTransaction(
        kind: TransactionKind.expense,
        amount: 5000,
        accountId: acc1Id,
        receivableId: 1,
        occurredAt: DateTime.now(),
      );
      expect(res.isError, isTrue);
      expect(res.errorOrNull!.code, FailureCode.invalidAmount);
    });
  });

  group('Transactions CRUD, Transfers & Undo (T-023, T-024, RN-28)', () {
    test('registers expense and reduces account balance', () async {
      final txRes = await addTransaction(
        kind: TransactionKind.expense,
        amount: 20000,
        accountId: acc1Id,
        occurredAt: DateTime.now(),
        note: 'Mercado',
      );

      expect(txRes.isOk, isTrue);
      final bal = await accountRepository.getAccountBalance(acc1Id);
      expect(bal.valueOrNull!.units, 80000);
    });

    test('registers income and increases account balance', () async {
      final txRes = await addTransaction(
        kind: TransactionKind.income,
        amount: 30000,
        accountId: acc1Id,
        occurredAt: DateTime.now(),
      );

      expect(txRes.isOk, isTrue);
      final bal = await accountRepository.getAccountBalance(acc1Id);
      expect(bal.valueOrNull!.units, 130000);
    });

    test('updates transaction note and amount', () async {
      final tx = (await addTransaction(
        kind: TransactionKind.expense,
        amount: 10000,
        accountId: acc1Id,
        occurredAt: DateTime.now(),
        note: 'Original',
      )).valueOrNull!;

      final updateRes = await updateTransaction(
        id: tx.id,
        amount: 12000,
        note: 'Modificado',
      );
      expect(updateRes.isOk, isTrue);
      expect(updateRes.valueOrNull!.amount, 12000);
      expect(updateRes.valueOrNull!.note, 'Modificado');
    });

    test('T-024: transfer moves funds between accounts without affecting global balance', () async {
      final res = await transferBetweenAccounts(
        sourceAccountId: acc1Id,
        targetAccountId: acc2Id,
        amount: 25000,
        occurredAt: DateTime.now(),
        note: 'Pasar a banco',
      );

      expect(res.isOk, isTrue);

      final bal1 = await accountRepository.getAccountBalance(acc1Id);
      final bal2 = await accountRepository.getAccountBalance(acc2Id);

      expect(bal1.valueOrNull!.units, 75000); // 100000 - 25000
      expect(bal2.valueOrNull!.units, 75000); // 50000 + 25000
    });

    test(
      'RN-28: soft delete and restore (undo) recalculates balance',
      () async {
        final tx = (await addTransaction(
          kind: TransactionKind.expense,
          amount: 40000,
          accountId: acc1Id,
          occurredAt: DateTime.now(),
        )).valueOrNull!;

        expect(
          (await accountRepository.getAccountBalance(acc1Id))
              .valueOrNull!
              .units,
          60000,
        );

        // Soft delete
        final delRes = await deleteTransaction(tx.id);
        expect(delRes.isOk, isTrue);

        // Balance returns to 100000 because deleted_at != null
        expect(
          (await accountRepository.getAccountBalance(acc1Id))
              .valueOrNull!
              .units,
          100000,
        );

        // Restore (Deshacer)
        final restoreRes = await restoreTransaction(tx.id);
        expect(restoreRes.isOk, isTrue);
        expect(restoreRes.valueOrNull!.deletedAt, isNull);

        // Balance is 60000 again
        expect(
          (await accountRepository.getAccountBalance(acc1Id))
              .valueOrNull!
              .units,
          60000,
        );
      },
    );

    test('T-025: search and filter transactions', () async {
      await addTransaction(
        kind: TransactionKind.expense,
        amount: 15000,
        accountId: acc1Id,
        occurredAt: DateTime(2026, 10, 1),
        note: 'Gasolina moto',
      );
      await addTransaction(
        kind: TransactionKind.income,
        amount: 80000,
        accountId: acc1Id,
        occurredAt: DateTime(2026, 10, 5),
        note: 'Sueldo quincenal',
      );

      // Filter by text
      final textFiltered = await repository.getTransactions(
        const TransactionFilter(searchQuery: 'Gasolina'),
      );
      expect(textFiltered.length, 1);
      expect(textFiltered.first.note, 'Gasolina moto');

      // Filter by kind
      final incomeFiltered = await repository.getTransactions(
        const TransactionFilter(kind: TransactionKind.income),
      );
      expect(incomeFiltered.length, 1);
      expect(incomeFiltered.first.note, 'Sueldo quincenal');
    });
  });
}
