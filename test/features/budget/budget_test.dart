import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:finanzas_personales/features/budget/domain/entities/allocation_rule.dart';
import 'package:finanzas_personales/features/budget/domain/usecases/compute_extra_income_split.dart';
import 'package:finanzas_personales/features/budget/domain/usecases/compute_safe_available.dart';
import 'package:finanzas_personales/features/budget/domain/usecases/set_allocation_rules.dart';
import 'package:finanzas_personales/features/budget/domain/usecases/set_base_income.dart';
import 'package:finanzas_personales/features/debts/data/repositories/debt_repository_impl.dart';
import 'package:finanzas_personales/features/debts/domain/entities/debt.dart';
import 'package:finanzas_personales/features/debts/domain/usecases/create_debt.dart';
import 'package:finanzas_personales/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late BudgetRepositoryImpl budgetRepository;
  late DebtRepositoryImpl debtRepository;

  late SetBaseIncome setBaseIncome;
  late SetAllocationRules setAllocationRules;
  late ComputeExtraIncomeSplit computeExtraIncomeSplit;
  late ComputeSafeAvailable computeSafeAvailable;
  late CreateDebt createDebt;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    budgetRepository = BudgetRepositoryImpl(db);
    debtRepository = DebtRepositoryImpl(db);

    setBaseIncome = SetBaseIncome(budgetRepository);
    setAllocationRules = SetAllocationRules(budgetRepository);
    computeExtraIncomeSplit = ComputeExtraIncomeSplit(budgetRepository);
    computeSafeAvailable = ComputeSafeAvailable(
      budgetRepository: budgetRepository,
      debtRepository: debtRepository,
    );
    createDebt = CreateDebt(debtRepository);
  });

  tearDown(() async {
    await db.close();
  });

  group('Budget & Extra Income Rules (T-060, T-061, T-062, RN-04 to RN-12)', () {
    test('RN-04: configures monthly base income', () async {
      final res = await setBaseIncome(1400000);
      expect(res.isOk, isTrue);

      final current = await budgetRepository.getBaseIncome();
      expect(current.valueOrNull, 1400000);
    });

    test('RN-05 & T-062: safe available calculated on base income and flags deficit', () async {
      await setBaseIncome(1200000);

      // Create a debt with minPayment = 150000
      await createDebt(
        name: 'Tarjeta',
        creditor: 'Banco',
        initialAmount: 600000,
        interestRateBp: 200,
        minPayment: 150000,
        dueDay: 10,
      );

      // Safe available = 1200000 - 300000 (fixed) - 150000 (min debt) - 50000 (savings) = 700000
      final safeRes = await computeSafeAvailable(
        fixedExpenses: 300000,
        savingsContribution: 50000,
      );

      expect(safeRes.isOk, isTrue);
      final safe = safeRes.valueOrNull!;
      expect(safe.baseIncome, 1200000);
      expect(safe.debtMinPayments, 150000);
      expect(safe.fixedExpenses, 300000);
      expect(safe.savingsContribution, 50000);
      expect(safe.safeAvailable, 700000);
      expect(safe.isDeficit, isFalse);

      // Test Deficit case
      final deficitRes = await computeSafeAvailable(
        fixedExpenses: 1100000, // 1200000 - 1100000 - 150000 = -50000
      );
      expect(deficitRes.valueOrNull!.safeAvailable, -50000);
      expect(deficitRes.valueOrNull!.isDeficit, isTrue);
    });

    test('RN-09 & RN-10: allocation rules must sum to 100% and defaults to 50/20/30', () async {
      // Check default rules seeded (RN-10)
      final defaults =
          (await budgetRepository.getAllocationRules()).valueOrNull!;
      expect(
        defaults.firstWhere((r) => r.target == AllocationTarget.debts).percent,
        50,
      );
      expect(
        defaults
            .firstWhere((r) => r.target == AllocationTarget.savings)
            .percent,
        20,
      );
      expect(
        defaults.firstWhere((r) => r.target == AllocationTarget.free).percent,
        30,
      );

      // Invalid sum: 40 + 20 + 30 = 90
      final invalidRes = await setAllocationRules(
        debtsPercent: 40,
        savingsPercent: 20,
        freePercent: 30,
      );
      expect(invalidRes.isError, isTrue);
      expect(
        invalidRes.errorOrNull!.code,
        FailureCode.invalidAllocationRulePercentSum,
      );

      // Valid sum: 40 + 30 + 30 = 100
      final validRes = await setAllocationRules(
        debtsPercent: 40,
        savingsPercent: 30,
        freePercent: 30,
      );
      expect(validRes.isOk, isTrue);
    });

    test('RN-06, RN-07, RN-11, RN-12: extra income split calculation & deficit handling', () async {
      await setBaseIncome(1000000);

      // RN-07: Actual income < base income (deficit, no split suggested)
      final underRes = await computeExtraIncomeSplit(
        actualMonthlyIncome: 850000,
      );
      expect(underRes.isOk, isTrue);
      final under = underRes.valueOrNull!;
      expect(under.hasDeficit, isTrue);
      expect(under.totalExtraIncome, 0);
      expect(under.debtsAmount, 0);

      // RN-06: Actual income > base income -> extra = 1500000 - 1000000 = 500000
      // 50% debts = 250000, 20% savings = 100000, 30% free = 150000
      final overRes = await computeExtraIncomeSplit(
        actualMonthlyIncome: 1500000,
      );
      expect(overRes.isOk, isTrue);
      final over = overRes.valueOrNull!;
      expect(over.hasDeficit, isFalse);
      expect(over.totalExtraIncome, 500000);
      expect(over.debtsAmount, 250000);
      expect(over.savingsAmount, 100000);
      expect(over.freeAmount, 150000);

      // RN-12: Verify no transactions were created automatically (split is purely a suggestion)
      final transactions = await db.select(db.transactionsTable).get();
      expect(transactions.isEmpty, isTrue);
    });

    test('real-time cash flow: tracks shortfall when spending in deficit and surplus when daily/extra income arrives', () async {
      final accountRepo = AccountRepositoryImpl(db);
      final txRepo = TransactionRepositoryImpl(db);
      final liveCompute = ComputeSafeAvailable(
        budgetRepository: budgetRepository,
        debtRepository: debtRepository,
        accountRepository: accountRepo,
      );

      // User starts with 100,000 in cash
      final cashAcc = (await accountRepo.createAccount(
        name: 'Efectivo',
        type: AccountType.cash,
        initialBalance: 100000,
      )).valueOrNull!;

      // Debt 1: Personal debt due in 7 days for 80,000 (0% interest)
      await createDebt(
        name: 'Deuda Amigo',
        creditor: 'Pedro',
        initialAmount: 80000,
        interestRateBp: 0,
        minPayment: 80000,
        dueDay: 7,
        debtType: DebtType.personal,
        frequencyType: DebtFrequency.inDays,
        intervalDays: 7,
      );

      // Debt 2: Credit card with minPayment 50,000 + management fee 20,000 = 70,000
      await createDebt(
        name: 'Tarjeta',
        creditor: 'Banco',
        initialAmount: 300000,
        interestRateBp: 240,
        minPayment: 50000,
        dueDay: 15,
        debtType: DebtType.creditCard,
        hasManagementFee: true,
        managementFee: 20000,
        frequencyType: DebtFrequency.inDays,
        intervalDays: 9,
      );

      // Total debt obligation = 80,000 + 70,000 = 150,000.
      // Liquid balance = 100,000 -> Shortfall = 50,000
      final res1 = (await liveCompute()).valueOrNull!;
      expect(res1.liquidBalance, 100000);
      expect(res1.debtMinPayments, 150000);
      expect(res1.totalManagementFees, 20000);
      expect(res1.isEffectiveDeficit, isTrue);
      expect(res1.shortfallForDebts, 50000);

      // User makes an expense of 25,000 even though they don't have enough for debts
      await txRepo.addTransaction(
        kind: TransactionKind.expense,
        amount: 25000,
        accountId: cashAcc.id,
        occurredAt: DateTime.now(),
        note: 'Almuerzo',
      );

      // Now shortfall increases from 50,000 to 75,000!
      final res2 = (await liveCompute()).valueOrNull!;
      expect(res2.liquidBalance, 75000);
      expect(res2.shortfallForDebts, 75000);

      // User works every day and earns 120,000 salary + 40,000 extra = 160,000
      await txRepo.addTransaction(
        kind: TransactionKind.income,
        amount: 160000,
        accountId: cashAcc.id,
        occurredAt: DateTime.now(),
        note: 'Días trabajados + extra',
      );

      // Liquid balance = 75,000 + 160,000 = 235,000.
      // Subtracting 150,000 debt obligations leaves 85,000 surplus!
      final res3 = (await liveCompute()).valueOrNull!;
      expect(res3.liquidBalance, 235000);
      expect(res3.isEffectiveDeficit, isFalse);
      expect(res3.shortfallForDebts, 0);
      expect(res3.surplusAfterDebts, 85000);
    });
  });
}
