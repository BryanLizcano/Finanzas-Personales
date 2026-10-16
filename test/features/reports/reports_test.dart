import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:finanzas_personales/features/categories/data/repositories/category_repository_impl.dart';
import 'package:finanzas_personales/features/debts/data/repositories/debt_repository_impl.dart';
import 'package:finanzas_personales/features/receivables/data/repositories/receivable_repository_impl.dart';
import 'package:finanzas_personales/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:finanzas_personales/features/reports/domain/usecases/get_category_breakdown.dart';
import 'package:finanzas_personales/features/reports/domain/usecases/get_monthly_summary.dart';
import 'package:finanzas_personales/features/reports/domain/usecases/get_monthly_totals.dart';
import 'package:finanzas_personales/features/savings/data/repositories/savings_repository_impl.dart';
import 'package:finanzas_personales/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ReportsRepositoryImpl reportsRepository;
  late AccountRepositoryImpl accountRepository;
  late CategoryRepositoryImpl categoryRepository;
  late TransactionRepositoryImpl transactionRepository;
  late DebtRepositoryImpl debtRepository;
  late ReceivableRepositoryImpl receivableRepository;
  late SavingsRepositoryImpl savingsRepository;
  late BudgetRepositoryImpl budgetRepository;

  late GetMonthlySummary getMonthlySummary;
  late GetCategoryBreakdown getCategoryBreakdown;
  late GetMonthlyTotals getMonthlyTotals;

  late int accountId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    accountRepository = AccountRepositoryImpl(db);
    categoryRepository = CategoryRepositoryImpl(db);
    transactionRepository = TransactionRepositoryImpl(db);
    debtRepository = DebtRepositoryImpl(db);
    receivableRepository = ReceivableRepositoryImpl(db);
    savingsRepository = SavingsRepositoryImpl(db);
    budgetRepository = BudgetRepositoryImpl(db);

    reportsRepository = ReportsRepositoryImpl(
      db: db,
      debtRepository: debtRepository,
      receivableRepository: receivableRepository,
      savingsRepository: savingsRepository,
      budgetRepository: budgetRepository,
    );

    getMonthlySummary = GetMonthlySummary(reportsRepository);
    getCategoryBreakdown = GetCategoryBreakdown(reportsRepository);
    getMonthlyTotals = GetMonthlyTotals(reportsRepository);

    final acc = (await accountRepository.createAccount(
      name: 'Principal',
      type: AccountType.bank,
      initialBalance: 2000000,
    )).valueOrNull!;
    accountId = acc.id;

    await budgetRepository.setBaseIncome(1200000);
  });

  tearDown(() async {
    await db.close();
  });

  group('Reports (T-070, T-071, T-072, RN-22, RN-23)', () {
    test(
      'monthly summary consolidates income, expenses and balances',
      () async {
        final now = DateTime(2026, 10, 15);

        // Register income
        await transactionRepository.addTransaction(
          kind: TransactionKind.income,
          amount: 1500000,
          accountId: accountId,
          occurredAt: now,
        );

        // Register expense
        await transactionRepository.addTransaction(
          kind: TransactionKind.expense,
          amount: 300000,
          accountId: accountId,
          occurredAt: now,
        );

        final summaryRes = await getMonthlySummary(year: 2026, month: 10);
        expect(summaryRes.isOk, isTrue);
        final summary = summaryRes.valueOrNull!;

        expect(summary.totalIncome, 1500000);
        expect(summary.totalExpense, 300000);
        expect(summary.balance, 1200000);
        expect(summary.baseIncome, 1200000);
      },
    );

    test('category breakdown calculates percentages correctly', () async {
      final now = DateTime(2026, 10, 10);
      final foodCat = (await categoryRepository.getCategoryByKey('food'))
          .valueOrNull!;
      final hygieneCat = (await categoryRepository.getCategoryByKey('hygiene'))
          .valueOrNull!;

      // 60,000 food
      await transactionRepository.addTransaction(
        kind: TransactionKind.expense,
        amount: 60000,
        accountId: accountId,
        categoryId: foodCat.id,
        occurredAt: now,
      );

      // 40,000 hygiene
      await transactionRepository.addTransaction(
        kind: TransactionKind.expense,
        amount: 40000,
        accountId: accountId,
        categoryId: hygieneCat.id,
        occurredAt: now,
      );

      final breakdownRes = await getCategoryBreakdown(year: 2026, month: 10);
      expect(breakdownRes.isOk, isTrue);
      final items = breakdownRes.valueOrNull!;

      expect(items.length, 2);
      expect(items[0].categoryId, foodCat.id);
      expect(items[0].totalAmount, 60000);
      expect(items[0].percentage, 60.0);

      expect(items[1].categoryId, hygieneCat.id);
      expect(items[1].totalAmount, 40000);
      expect(items[1].percentage, 40.0);
    });

    test(
      'RN-22: Moto report groups fuel, moto_maintenance and moto_documents',
      () async {
        final now = DateTime(2026, 10, 12);
        final fuel = (await categoryRepository.getCategoryByKey('fuel'))
            .valueOrNull!;
        final maint = (await categoryRepository.getCategoryByKey(
          'moto_maintenance',
        )).valueOrNull!;
        final docs = (await categoryRepository.getCategoryByKey(
          'moto_documents',
        )).valueOrNull!;
        final food = (await categoryRepository.getCategoryByKey('food'))
            .valueOrNull!;

        await transactionRepository.addTransaction(
          kind: TransactionKind.expense,
          amount: 30000,
          accountId: accountId,
          categoryId: fuel.id,
          occurredAt: now,
        );
        await transactionRepository.addTransaction(
          kind: TransactionKind.expense,
          amount: 50000,
          accountId: accountId,
          categoryId: maint.id,
          occurredAt: now,
        );
        await transactionRepository.addTransaction(
          kind: TransactionKind.expense,
          amount: 20000,
          accountId: accountId,
          categoryId: docs.id,
          occurredAt: now,
        );
        // Food should not be counted in Moto
        await transactionRepository.addTransaction(
          kind: TransactionKind.expense,
          amount: 40000,
          accountId: accountId,
          categoryId: food.id,
          occurredAt: now,
        );

        final motoRes = await reportsRepository.getGroupedExpenses(
          year: 2026,
          month: 10,
          categoryKeys: ['fuel', 'moto_maintenance', 'moto_documents'],
          groupName: 'Moto',
        );

        expect(motoRes.isOk, isTrue);
        expect(motoRes.valueOrNull!.totalAmount, 100000);
      },
    );

    test(
      'RN-23: Outings & Partner report groups partner and outings',
      () async {
        final now = DateTime(2026, 10, 14);
        final partner = (await categoryRepository.getCategoryByKey('partner'))
            .valueOrNull!;
        final outings = (await categoryRepository.getCategoryByKey('outings'))
            .valueOrNull!;

        await transactionRepository.addTransaction(
          kind: TransactionKind.expense,
          amount: 45000,
          accountId: accountId,
          categoryId: partner.id,
          occurredAt: now,
        );
        await transactionRepository.addTransaction(
          kind: TransactionKind.expense,
          amount: 55000,
          accountId: accountId,
          categoryId: outings.id,
          occurredAt: now,
        );

        final coupleRes = await reportsRepository.getGroupedExpenses(
          year: 2026,
          month: 10,
          categoryKeys: ['partner', 'outings'],
          groupName: 'Salidas y pareja',
        );

        expect(coupleRes.isOk, isTrue);
        expect(coupleRes.valueOrNull!.totalAmount, 100000);
      },
    );

    test('getMonthlyTotals returns historical monthly totals', () async {
      final totals = await getMonthlyTotals(numberOfMonths: 6);
      expect(totals.isOk, isTrue);
      expect(totals.valueOrNull, isNotEmpty);
    });

    test('Performance test: 10,000 transactions aggregated in SQL execute in < 200 ms', () async {
      // Bulk insert 10,000 transactions in a single transaction
      final date = DateTime(2026, 10, 1);
      final now = DateTime.now();

      await db.batch((batch) {
        final companions = <TransactionsTableCompanion>[];
        for (var i = 0; i < 10000; i++) {
          companions.add(
            TransactionsTableCompanion.insert(
              kind: i % 5 == 0 ? 'income' : 'expense',
              amount: 1000 + (i % 100) * 10,
              accountId: accountId,
              occurredAt: date,
              createdAt: now,
              updatedAt: now,
            ),
          );
        }
        batch.insertAll(db.transactionsTable, companions);
      });

      final stopwatch = Stopwatch()..start();
      final summaryRes = await getMonthlySummary(year: 2026, month: 10);
      stopwatch.stop();

      expect(summaryRes.isOk, isTrue);
      expect(summaryRes.valueOrNull!.totalIncome, isPositive);
      expect(summaryRes.valueOrNull!.totalExpense, isPositive);

      // Verify execution time is well under 200 ms
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(200),
        reason: 'Execution took ${stopwatch.elapsedMilliseconds} ms',
      );
    });
  });
}
