import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/accounts/domain/usecases/watch_accounts_with_balance.dart';
import 'package:finanzas_personales/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:finanzas_personales/features/categories/data/repositories/category_repository_impl.dart';
import 'package:finanzas_personales/features/debts/data/repositories/debt_repository_impl.dart';
import 'package:finanzas_personales/features/debts/domain/usecases/create_debt.dart';
import 'package:finanzas_personales/features/receivables/data/repositories/receivable_repository_impl.dart';
import 'package:finanzas_personales/features/receivables/domain/usecases/create_receivable.dart';
import 'package:finanzas_personales/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:finanzas_personales/features/reports/domain/usecases/get_monthly_totals.dart';
import 'package:finanzas_personales/features/savings/data/repositories/savings_repository_impl.dart';
import 'package:finanzas_personales/features/savings/domain/usecases/create_savings_goal.dart';
import 'package:finanzas_personales/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:finanzas_personales/features/transactions/domain/usecases/add_transaction.dart';
import 'package:finanzas_personales/features/transactions/domain/usecases/update_transaction.dart';
import 'package:finanzas_personales/features/transactions/domain/usecases/watch_transactions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late AccountRepositoryImpl accountRepo;
  late TransactionRepositoryImpl txRepo;
  late CategoryRepositoryImpl catRepo;
  late DebtRepositoryImpl debtRepo;
  late ReceivableRepositoryImpl recRepo;
  late SavingsRepositoryImpl savRepo;
  late BudgetRepositoryImpl budRepo;
  late ReportsRepositoryImpl repRepo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    accountRepo = AccountRepositoryImpl(db);
    txRepo = TransactionRepositoryImpl(db);
    catRepo = CategoryRepositoryImpl(db);
    debtRepo = DebtRepositoryImpl(db);
    recRepo = ReceivableRepositoryImpl(db);
    savRepo = SavingsRepositoryImpl(db);
    budRepo = BudgetRepositoryImpl(db);
    repRepo = ReportsRepositoryImpl(
      db: db,
      debtRepository: debtRepo,
      receivableRepository: recRepo,
      savingsRepository: savRepo,
      budgetRepository: budRepo,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Additional Use Cases Coverage', () {
    test(
      'WatchAccountsWithBalance and WatchTransactions streams emit',
      () async {
        final watchAccounts = WatchAccountsWithBalance(accountRepo);
        final watchTxs = WatchTransactions(txRepo);

        final acc = (await accountRepo.createAccount(
          name: 'Stream Account',
          type: AccountType.bank,
          initialBalance: 500,
        )).valueOrNull!;

        final accs = await watchAccounts().first;
        expect(accs.length, 1);
        expect(accs.first.account.name, 'Stream Account');

        final addTx = AddTransaction(txRepo);
        await addTx(
          kind: TransactionKind.income,
          amount: 100,
          accountId: acc.id,
          occurredAt: DateTime.now(),
        );

        final txs = await watchTxs().first;
        expect(txs.length, 1);
        expect(txs.first.amount, 100);
      },
    );

    test(
      'UpdateTransaction updates fields and validates invalid amounts',
      () async {
        final acc = (await accountRepo.createAccount(
          name: 'Test',
          type: AccountType.cash,
          initialBalance: 100,
        )).valueOrNull!;

        final addTx = AddTransaction(txRepo);
        final tx = (await addTx(
          kind: TransactionKind.expense,
          amount: 50,
          accountId: acc.id,
          occurredAt: DateTime.now(),
        )).valueOrNull!;

        final updateTx = UpdateTransaction(txRepo);

        // Invalid amount <= 0
        final invalidRes = await updateTx(id: tx.id, amount: -10);
        expect(invalidRes.isError, isTrue);

        // Same account transfer
        final invalidTransfer = await updateTx(
          id: tx.id,
          accountId: acc.id,
          toAccountId: acc.id,
        );
        expect(invalidTransfer.isError, isTrue);

        // Valid update
        final validRes = await updateTx(id: tx.id, amount: 60, note: 'Updated');
        expect(validRes.isOk, isTrue);
        expect(validRes.valueOrNull!.amount, 60);
        expect(validRes.valueOrNull!.note, 'Updated');
      },
    );

    test('GetMonthlyTotals usecase executes', () async {
      final getTotals = GetMonthlyTotals(repRepo);
      final res = await getTotals(numberOfMonths: 3);
      expect(res.isOk, isTrue);
      expect(res.valueOrNull!.length, 3);
    });

    test('Reminders creation and marking as done', () async {
      final rem = (await repRepo.createReminder(
        title: 'Tecnomecánica',
        dueAt: DateTime.now().add(const Duration(days: 10)),
      )).valueOrNull!;

      expect(rem.done, isFalse);

      await repRepo.setReminderDone(id: rem.id, done: true);

      final list = await repRepo.watchPendingReminders().first;
      expect(list.any((r) => r.id == rem.id), isFalse);
    });

    test(
      'Watch categories, debts, receivables and savings goals emit',
      () async {
        final createD = CreateDebt(debtRepo);
        await createD(
          name: 'D1',
          creditor: 'C1',
          initialAmount: 100,
          interestRateBp: 0,
          minPayment: 10,
          dueDay: 1,
        );
        final debts = await debtRepo.watchDebtsWithBalance().first;
        expect(debts.length, 1);

        final createR = CreateReceivable(recRepo);
        await createR(
          person: 'P1',
          initialAmount: 100,
          createdAt: DateTime.now(),
        );
        final recs = await recRepo.watchReceivablesWithBalance().first;
        expect(recs.length, 1);

        final createG = CreateSavingsGoal(savRepo);
        await createG(name: 'G1', targetAmount: 100);
        final goals = await savRepo.watchGoalsWithProgress().first;
        expect(goals.length, 1);

        final cats = await catRepo.watchCategories().first;
        expect(cats.isNotEmpty, isTrue);
      },
    );
  });
}
