import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/categories/data/repositories/category_repository_impl.dart';
import 'package:finanzas_personales/features/receivables/data/repositories/receivable_repository_impl.dart';
import 'package:finanzas_personales/features/receivables/domain/usecases/create_receivable.dart';
import 'package:finanzas_personales/features/receivables/domain/usecases/register_collection.dart';
import 'package:finanzas_personales/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ReceivableRepositoryImpl receivableRepository;
  late CategoryRepositoryImpl categoryRepository;
  late TransactionRepositoryImpl transactionRepository;
  late AccountRepositoryImpl accountRepository;

  late CreateReceivable createReceivable;
  late RegisterCollection registerCollection;

  late int accountId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    receivableRepository = ReceivableRepositoryImpl(db);
    categoryRepository = CategoryRepositoryImpl(db);
    transactionRepository = TransactionRepositoryImpl(db);
    accountRepository = AccountRepositoryImpl(db);

    createReceivable = CreateReceivable(receivableRepository);
    registerCollection = RegisterCollection(
      receivableRepository: receivableRepository,
      categoryRepository: categoryRepository,
      transactionRepository: transactionRepository,
    );

    final acc = (await accountRepository.createAccount(
      name: 'Efectivo',
      type: AccountType.cash,
      initialBalance: 50000,
    )).valueOrNull!;
    accountId = acc.id;
  });

  tearDown(() async {
    await db.close();
  });

  group('Receivables (T-040, T-041, RN-18, RN-19, RN-20, RN-21)', () {
    test('creates receivable and tracks pending balance', () async {
      final res = await createReceivable(
        person: 'Pedro Gómez',
        initialAmount: 200000,
        createdAt: DateTime.now(),
        note: 'Para repuesto moto',
      );

      expect(res.isOk, isTrue);
      final rec = res.valueOrNull!;
      expect(rec.person, 'Pedro Gómez');
      expect(rec.initialAmount, 200000);

      final withBal = (await receivableRepository.getReceivableWithBalance(
        rec.id,
      )).valueOrNull!;
      expect(withBal.pendingBalance, 200000);
      expect(withBal.collectedAmount, 0);
      expect(withBal.isSettled, isFalse);
    });

    test('RN-18 & RN-20: collection creates income linked to receivable and cannot exceed balance', () async {
      final rec = (await createReceivable(
        person: 'Laura',
        initialAmount: 80000,
        createdAt: DateTime.now(),
      )).valueOrNull!;

      // RN-20: cannot exceed pending balance
      final excessRes = await registerCollection(
        receivableId: rec.id,
        amount: 90000,
        accountId: accountId,
        occurredAt: DateTime.now(),
      );
      expect(excessRes.isError, isTrue);
      expect(
        excessRes.errorOrNull!.code,
        FailureCode.receivableCollectionExceedsBalance,
      );

      // RN-18: valid collection creates income transaction with loan_collection category
      final validRes = await registerCollection(
        receivableId: rec.id,
        amount: 30000,
        accountId: accountId,
        occurredAt: DateTime.now(),
      );
      expect(validRes.isOk, isTrue);
      final tx = validRes.valueOrNull!;
      expect(tx.kind, TransactionKind.income);
      expect(tx.receivableId, rec.id);

      final loanCat = (await categoryRepository.getCategoryByKey(
        'loan_collection',
      )).valueOrNull!;
      expect(tx.categoryId, loanCat.id);

      // Account balance increased: 50000 + 30000 = 80000
      final accBal = await accountRepository.getAccountBalance(accountId);
      expect(accBal.valueOrNull!.units, 80000);

      // Pending balance reduced: 80000 - 30000 = 50000
      final updatedRec = (await receivableRepository.getReceivableWithBalance(
        rec.id,
      )).valueOrNull!;
      expect(updatedRec.pendingBalance, 50000);
      expect(updatedRec.collectedAmount, 30000);
      expect(updatedRec.isSettled, isFalse);
    });

    test('RN-21: total pending receivable is tracked separately', () async {
      await createReceivable(
        person: 'Persona 1',
        initialAmount: 100000,
        createdAt: DateTime.now(),
      );
      await createReceivable(
        person: 'Persona 2',
        initialAmount: 150000,
        createdAt: DateTime.now(),
      );

      final total = await receivableRepository.getTotalPendingReceivable();
      expect(total, 250000);

      // The account initial balance is still 50000 (not mixed with pending receivables)
      final accBal = await accountRepository.getAccountBalance(accountId);
      expect(accBal.valueOrNull!.units, 50000);
    });
  });
}
