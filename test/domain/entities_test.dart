// ignore_for_file: unrelated_type_equality_checks
import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/core/money/currency.dart';
import 'package:finanzas_personales/core/money/money.dart';
import 'package:finanzas_personales/core/result/result.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account_with_balance.dart';
import 'package:finanzas_personales/features/budget/domain/entities/allocation_rule.dart';
import 'package:finanzas_personales/features/categories/domain/entities/category.dart';
import 'package:finanzas_personales/features/debts/domain/entities/debt.dart';
import 'package:finanzas_personales/features/quick_add/domain/entities/quick_add_payload.dart';
import 'package:finanzas_personales/features/receivables/domain/entities/receivable.dart';
import 'package:finanzas_personales/features/reports/domain/entities/report_models.dart';
import 'package:finanzas_personales/features/savings/domain/entities/savings_goal.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:finanzas_personales/features/updates/domain/entities/update_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Domain Entities Coverage & Equality Tests', () {
    test('Account and AccountWithBalance equality and copyWith', () {
      const a1 = Account(
        id: 1,
        name: 'Banco',
        type: AccountType.bank,
        initialBalance: 1000,
        archived: false,
      );
      final a2 = a1.copyWith(
        name: 'Banco 2',
        type: AccountType.savings,
        initialBalance: 2000,
        archived: true,
      );

      expect(a1 == a2, isFalse);
      expect((a1 as dynamic) == 'not an account', isFalse);
      expect(a1.hashCode, isNotNull);
      expect(a2.name, 'Banco 2');
      expect(a2.type, AccountType.savings);
      expect(a2.initialBalance, 2000);
      expect(a2.archived, isTrue);
      expect(AccountType.fromString('bank'), AccountType.bank);
      expect(AccountType.fromString('savings'), AccountType.savings);
      expect(AccountType.fromString('other'), AccountType.cash);

      const awb1 = AccountWithBalance(account: a1, balance: Money(units: 1000));
      const awb2 = AccountWithBalance(account: a1, balance: Money(units: 1000));
      const awb3 = AccountWithBalance(account: a1, balance: Money(units: 2000));
      expect(awb1 == awb2, isTrue);
      expect(awb1 == awb3, isFalse);
      expect((awb1 as dynamic) == 'not awb', isFalse);
      expect(awb1.hashCode, awb2.hashCode);
    });

    test('Category copyWith and equality', () {
      const c1 = Category(
        id: 1,
        key: 'food',
        name: 'Alimentación',
        kind: CategoryKind.expense,
        icon: 'food',
        color: 123,
        isDefault: true,
        isActive: true,
        sortOrder: 1,
      );
      final c2 = c1.copyWith(
        name: 'Comida',
        icon: 'other_icon',
        color: 456,
        isActive: false,
        sortOrder: 2,
      );

      expect(c1 == c2, isFalse);
      expect((c1 as dynamic) == 'not cat', isFalse);
      expect(c1.hashCode, isNotNull);
      const custom = Category(
        id: 2,
        name: 'Comida',
        kind: CategoryKind.expense,
        icon: 'food',
        color: 123,
        isDefault: false,
      );
      expect(c1.displayName((k) => 'Comida Traducida'), 'Comida Traducida');
      expect(custom.displayName((k) => 'Otro'), 'Comida');
      expect(CategoryKind.fromString('income'), CategoryKind.income);
      expect(CategoryKind.fromString('expense'), CategoryKind.expense);
      expect(CategoryKind.fromString('other'), CategoryKind.expense);
    });

    test('TransactionEntity copyWith and equality', () {
      final now = DateTime.now();
      final t1 = TransactionEntity(
        id: 1,
        kind: TransactionKind.expense,
        amount: 500,
        accountId: 1,
        toAccountId: 2,
        categoryId: 3,
        debtId: 4,
        receivableId: 5,
        goalId: 6,
        occurredAt: now,
        note: 'nota',
        createdAt: now,
        updatedAt: now,
        deletedAt: null,
      );
      expect(t1.isDeleted, isFalse);

      final t2 = t1.copyWith(
        kind: TransactionKind.income,
        amount: 600,
        accountId: 2,
        toAccountId: 3,
        categoryId: 4,
        debtId: 5,
        receivableId: 6,
        goalId: 7,
        occurredAt: now.add(const Duration(days: 1)),
        note: 'nueva nota',
        updatedAt: now.add(const Duration(days: 1)),
        deletedAt: now,
      );
      expect(t2.isDeleted, isTrue);

      final t3 = t2.copyWith(clearDeletedAt: true);
      expect(t3.isDeleted, isFalse);

      expect(t1 == t2, isFalse);
      expect((t1 as dynamic) == 'not tx', isFalse);
      expect(t1.hashCode, isNotNull);
      expect(TransactionKind.fromString('income'), TransactionKind.income);
      expect(TransactionKind.fromString('expense'), TransactionKind.expense);
      expect(TransactionKind.fromString('transfer'), TransactionKind.transfer);
      expect(TransactionKind.fromString('other'), TransactionKind.transfer);
    });

    test('DebtEntity and DebtWithBalance copyWith and equality', () {
      const d1 = DebtEntity(
        id: 1,
        name: 'Deuda',
        creditor: 'Banco',
        initialAmount: 1000,
        interestRateBp: 100,
        minPayment: 100,
        dueDay: 5,
        priority: 1,
        archived: false,
      );
      final d2 = d1.copyWith(
        name: 'Deuda 2',
        creditor: 'Amigo',
        initialAmount: 2000,
        interestRateBp: 200,
        minPayment: 200,
        dueDay: 10,
        priority: 2,
        archived: true,
      );
      expect(d1 == d2, isFalse);
      expect((d1 as dynamic) == 'not debt', isFalse);
      expect(d1.hashCode, isNotNull);

      expect(DebtStrategy.fromString('snowball'), DebtStrategy.snowball);
      expect(DebtStrategy.fromString('avalanche'), DebtStrategy.avalanche);

      const dwb1 = DebtWithBalance(
        debt: d1,
        paidAmount: 200,
        currentBalance: 800,
      );
      const dwb2 = DebtWithBalance(
        debt: d1,
        paidAmount: 200,
        currentBalance: 800,
      );
      const dwb3 = DebtWithBalance(
        debt: d1,
        paidAmount: 1000,
        currentBalance: 0,
      );
      const dwbZero = DebtWithBalance(
        debt: DebtEntity(
          id: 2,
          name: 'Zero',
          creditor: 'C',
          initialAmount: 0,
          interestRateBp: 0,
          minPayment: 0,
          dueDay: 1,
          priority: 1,
        ),
        paidAmount: 0,
        currentBalance: 0,
      );

      expect(dwb1 == dwb2, isTrue);
      expect(dwb1 == dwb3, isFalse);
      expect((dwb1 as dynamic) == 'not dwb', isFalse);
      expect(dwb1.hashCode, dwb2.hashCode);
      expect(dwb1.isPaidOff, isFalse);
      expect(dwb3.isPaidOff, isTrue);
      expect(dwb1.progressRatio, 0.2);
      expect(dwbZero.progressRatio, 1.0);
    });

    test(
      'ReceivableEntity and ReceivableWithBalance copyWith and equality',
      () {
        final now = DateTime.now();
        final r1 = ReceivableEntity(
          id: 1,
          person: 'Carlos',
          initialAmount: 5000,
          createdAt: now,
          note: 'Nota',
          archived: false,
        );
        final r2 = r1.copyWith(
          person: 'Juan',
          initialAmount: 6000,
          createdAt: now.add(const Duration(days: 1)),
          note: 'Nota 2',
          archived: true,
        );
        expect(r1 == r2, isFalse);
        expect((r1 as dynamic) == 'not rec', isFalse);
        expect(r1.hashCode, isNotNull);

        final rwb1 = ReceivableWithBalance(
          receivable: r1,
          collectedAmount: 1000,
          pendingBalance: 4000,
        );
        final rwb2 = ReceivableWithBalance(
          receivable: r1,
          collectedAmount: 1000,
          pendingBalance: 4000,
        );
        final rwbSettled = ReceivableWithBalance(
          receivable: r1,
          collectedAmount: 5000,
          pendingBalance: 0,
        );
        final rwbZero = ReceivableWithBalance(
          receivable: ReceivableEntity(
            id: 2,
            person: 'Zero',
            initialAmount: 0,
            createdAt: now,
          ),
          collectedAmount: 0,
          pendingBalance: 0,
        );

        expect(rwb1 == rwb2, isTrue);
        expect(rwb1 == rwbSettled, isFalse);
        expect((rwb1 as dynamic) == 'not rwb', isFalse);
        expect(rwb1.hashCode, rwb2.hashCode);
        expect(rwb1.isSettled, isFalse);
        expect(rwbSettled.isSettled, isTrue);
        expect(rwb1.progressRatio, 0.2);
        expect(rwbZero.progressRatio, 1.0);
      },
    );

    test(
      'SavingsGoalEntity and SavingsGoalWithProgress copyWith and equality',
      () {
        final now = DateTime.now();
        final g1 = SavingsGoalEntity(
          id: 1,
          name: 'Meta',
          targetAmount: 5000,
          targetDate: now,
          archived: false,
        );
        final g2 = g1.copyWith(
          name: 'Meta 2',
          targetAmount: 10000,
          targetDate: now.add(const Duration(days: 30)),
          archived: true,
        );
        expect(g1 == g2, isFalse);
        expect((g1 as dynamic) == 'not goal', isFalse);
        expect(g1.hashCode, isNotNull);

        final gwb1 = SavingsGoalWithProgress(
          goal: g1,
          currentAmount: 2500,
          progressRatio: 0.5,
        );
        final gwb2 = SavingsGoalWithProgress(
          goal: g1,
          currentAmount: 2500,
          progressRatio: 0.5,
        );
        final gwbCompleted = SavingsGoalWithProgress(
          goal: g1,
          currentAmount: 5000,
          progressRatio: 1.0,
        );

        expect(gwb1 == gwb2, isTrue);
        expect(gwb1 == gwbCompleted, isFalse);
        expect((gwb1 as dynamic) == 'not gwb', isFalse);
        expect(gwb1.hashCode, gwb2.hashCode);
        expect(gwb1.isCompleted, isFalse);
        expect(gwbCompleted.isCompleted, isTrue);
      },
    );

    test('AllocationRule, ExtraIncomeSplit, SafeAvailableResult equality', () {
      const r1 = AllocationRule(
        id: 1,
        target: AllocationTarget.debts,
        percent: 50,
      );
      const r2 = AllocationRule(
        id: 1,
        target: AllocationTarget.debts,
        percent: 50,
      );
      const r3 = AllocationRule(
        id: 2,
        target: AllocationTarget.savings,
        percent: 20,
      );
      expect(r1 == r2, isTrue);
      expect(r1 == r3, isFalse);
      expect((r1 as dynamic) == 'not rule', isFalse);
      expect(r1.hashCode, r2.hashCode);
      expect(AllocationTarget.fromString('debts'), AllocationTarget.debts);
      expect(AllocationTarget.fromString('savings'), AllocationTarget.savings);
      expect(AllocationTarget.fromString('free'), AllocationTarget.free);
      expect(AllocationTarget.fromString('other'), AllocationTarget.free);

      const s1 = ExtraIncomeSplit(
        totalExtraIncome: 100,
        debtsAmount: 50,
        savingsAmount: 20,
        freeAmount: 30,
        hasDeficit: false,
      );
      const s2 = ExtraIncomeSplit(
        totalExtraIncome: 100,
        debtsAmount: 50,
        savingsAmount: 20,
        freeAmount: 30,
        hasDeficit: false,
      );
      const s3 = ExtraIncomeSplit(
        totalExtraIncome: 100,
        debtsAmount: 60,
        savingsAmount: 10,
        freeAmount: 30,
        hasDeficit: true,
      );
      expect(s1 == s2, isTrue);
      expect(s1 == s3, isFalse);
      expect((s1 as dynamic) == 'not split', isFalse);
      expect(s1.hashCode, s2.hashCode);

      const safe1 = SafeAvailableResult(
        baseIncome: 100,
        fixedExpenses: 10,
        debtMinPayments: 10,
        savingsContribution: 10,
        safeAvailable: 70,
        isDeficit: false,
      );
      const safe2 = SafeAvailableResult(
        baseIncome: 100,
        fixedExpenses: 10,
        debtMinPayments: 10,
        savingsContribution: 10,
        safeAvailable: 70,
        isDeficit: false,
      );
      const safe3 = SafeAvailableResult(
        baseIncome: 100,
        fixedExpenses: 50,
        debtMinPayments: 50,
        savingsContribution: 50,
        safeAvailable: -50,
        isDeficit: true,
      );
      expect(safe1 == safe2, isTrue);
      expect(safe1 == safe3, isFalse);
      expect((safe1 as dynamic) == 'not safe', isFalse);
      expect(safe1.hashCode, safe2.hashCode);
    });

    test('Report models equality and ReminderEntity', () {
      const sum1 = MonthlySummary(
        year: 2026,
        month: 10,
        totalIncome: 100,
        totalExpense: 50,
        balance: 50,
        totalDebtBalance: 10,
        totalReceivableBalance: 10,
        totalSaved: 10,
        baseIncome: 80,
        safeAvailable: 70,
      );
      const sum2 = MonthlySummary(
        year: 2026,
        month: 10,
        totalIncome: 100,
        totalExpense: 50,
        balance: 50,
        totalDebtBalance: 10,
        totalReceivableBalance: 10,
        totalSaved: 10,
        baseIncome: 80,
        safeAvailable: 70,
      );
      const sum3 = MonthlySummary(
        year: 2025,
        month: 11,
        totalIncome: 200,
        totalExpense: 100,
        balance: 100,
        totalDebtBalance: 20,
        totalReceivableBalance: 20,
        totalSaved: 20,
        baseIncome: 160,
        safeAvailable: 140,
      );
      expect(sum1 == sum2, isTrue);
      expect(sum1 == sum3, isFalse);
      expect((sum1 as dynamic) == 'not summary', isFalse);
      expect(sum1.hashCode, sum2.hashCode);

      const catItem1 = CategoryBreakdownItem(
        categoryId: 1,
        categoryKeyOrName: 'food',
        icon: 'food',
        color: 123,
        totalAmount: 50,
        percentage: 50.0,
      );
      const catItem2 = CategoryBreakdownItem(
        categoryId: 1,
        categoryKeyOrName: 'food',
        icon: 'food',
        color: 123,
        totalAmount: 50,
        percentage: 50.0,
      );
      const catItem3 = CategoryBreakdownItem(
        categoryId: 2,
        categoryKeyOrName: 'transport',
        icon: 'car',
        color: 456,
        totalAmount: 25,
        percentage: 25.0,
      );
      expect(catItem1 == catItem2, isTrue);
      expect(catItem1 == catItem3, isFalse);
      expect((catItem1 as dynamic) == 'not cat item', isFalse);
      expect(catItem1.hashCode, catItem2.hashCode);

      const monthItem1 = MonthlyTotalItem(
        year: 2026,
        month: 10,
        totalIncome: 100,
        totalExpense: 50,
      );
      const monthItem2 = MonthlyTotalItem(
        year: 2026,
        month: 10,
        totalIncome: 100,
        totalExpense: 50,
      );
      const monthItem3 = MonthlyTotalItem(
        year: 2025,
        month: 9,
        totalIncome: 80,
        totalExpense: 40,
      );
      expect(monthItem1 == monthItem2, isTrue);
      expect(monthItem1 == monthItem3, isFalse);
      expect((monthItem1 as dynamic) == 'not month item', isFalse);
      expect(monthItem1.hashCode, monthItem2.hashCode);

      const grouped1 = GroupedExpenseReport(
        groupName: 'Moto',
        categoryKeys: ['fuel'],
        totalAmount: 100,
      );
      const grouped2 = GroupedExpenseReport(
        groupName: 'Moto',
        categoryKeys: ['fuel'],
        totalAmount: 100,
      );
      const grouped3 = GroupedExpenseReport(
        groupName: 'Salidas',
        categoryKeys: ['partner'],
        totalAmount: 200,
      );
      expect(grouped1 == grouped2, isTrue);
      expect(grouped1 == grouped3, isFalse);
      expect((grouped1 as dynamic) == 'not grouped', isFalse);
      expect(grouped1.hashCode, grouped2.hashCode);

      final rem = ReminderEntity(
        id: 1,
        title: 'SOAT',
        dueAt: DateTime.now(),
        repeatRule: 'monthly',
        done: true,
      );
      expect(rem.id, 1);
      expect(rem.title, 'SOAT');
      expect(rem.repeatRule, 'monthly');
      expect(rem.done, isTrue);
    });

    test('QuickAddPayload equality', () {
      const q1 = QuickAddPayload(
        kind: TransactionKind.expense,
        categoryKey: 'food',
        amount: 100,
      );
      const q2 = QuickAddPayload(
        kind: TransactionKind.expense,
        categoryKey: 'food',
        amount: 100,
      );
      const q3 = QuickAddPayload(
        kind: TransactionKind.income,
        categoryKey: 'salary',
        amount: 500,
      );
      expect(q1 == q2, isTrue);
      expect(q1 == q3, isFalse);
      expect((q1 as dynamic) == 'not payload', isFalse);
      expect(q1.hashCode, q2.hashCode);
    });

    test('UpdateInfo equality and semver helper', () {
      const u1 = UpdateInfo(
        currentVersion: '1.0.0',
        latestVersion: '1.1.0',
        hasUpdate: true,
        releaseNotes: 'Notas',
        apkDownloadUrl: 'https://apk',
        sha256Expected: 'sha',
      );
      const u2 = UpdateInfo(
        currentVersion: '1.0.0',
        latestVersion: '1.1.0',
        hasUpdate: true,
        releaseNotes: 'Notas',
        apkDownloadUrl: 'https://apk',
        sha256Expected: 'sha',
      );
      const u3 = UpdateInfo(
        currentVersion: '1.0.0',
        latestVersion: '1.0.0',
        hasUpdate: false,
        releaseNotes: '',
        apkDownloadUrl: '',
      );
      expect(u1 == u2, isTrue);
      expect(u1 == u3, isFalse);
      expect((u1 as dynamic) == 'not update', isFalse);
      expect(u1.hashCode, u2.hashCode);

      expect(isNewerVersion('1.0.0', '1.0.1'), isTrue);
      expect(isNewerVersion('v1.0.0', 'v1.1.0'), isTrue);
      expect(isNewerVersion('2.0.0', '1.9.9'), isFalse);
      expect(isNewerVersion('1.2.3', '1.2.3'), isFalse);
    });

    test('Failure and Result equality and toString', () {
      const f1 = Failure(FailureCode.invalidAmount, 'error');
      const f2 = Failure(FailureCode.invalidAmount, 'error');
      const f3 = Failure(FailureCode.databaseError, 'other error');
      expect(f1 == f2, isTrue);
      expect(f1 == f3, isFalse);
      expect((f1 as dynamic) == 'not failure', isFalse);
      expect(f1.hashCode, f2.hashCode);
      expect(f1.toString(), contains('invalidAmount'));

      const rOk = Result<int, Failure>.ok(123);
      const rErr = Result<int, Failure>.error(f1);
      expect(rOk.isOk, isTrue);
      expect(rOk.isError, isFalse);
      expect(rOk.valueOrNull, 123);
      expect(rOk.errorOrNull, isNull);
      expect(rErr.isOk, isFalse);
      expect(rErr.isError, isTrue);
      expect(rErr.valueOrNull, isNull);
      expect(rErr.errorOrNull, f1);
      expect(rOk.toString(), contains('123'));
      expect(rErr.toString(), contains('error'));
    });

    test('Money operators and toString', () {
      const m1 = Money(units: 100, currency: Currency.usd);
      final m2 = Money.fromMajor(1, Currency.usd);
      const m3 = Money(units: 50, currency: Currency.usd);
      expect(m1 == m2, isTrue);
      expect(m1 == m3, isFalse);
      expect((m1 as dynamic) == 'not money', isFalse);
      expect(m1.hashCode, m2.hashCode);
      expect(m1.isPositive, isTrue);
      expect(m1.isZero, isFalse);
      expect(m1.isNegative, isFalse);
      expect(const Money(units: -100).isNegative, isTrue);
      expect(const Money(units: -100).abs().units, 100);
      expect(() => m1 ~/ 0, throwsArgumentError);
      expect(m1.toString(), contains('USD 100'));
    });
  });
}
