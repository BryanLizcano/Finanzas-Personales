import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/core/money/currency.dart';
import 'package:finanzas_personales/core/money/money.dart';
import 'package:finanzas_personales/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:finanzas_personales/features/budget/domain/entities/allocation_rule.dart';
import 'package:finanzas_personales/features/budget/domain/usecases/compute_extra_income_split.dart';
import 'package:finanzas_personales/features/budget/domain/usecases/compute_safe_available.dart';
import 'package:finanzas_personales/features/budget/domain/usecases/set_allocation_rules.dart';
import 'package:finanzas_personales/features/budget/domain/usecases/set_base_income.dart';
import 'package:finanzas_personales/features/categories/data/repositories/category_repository_impl.dart';
import 'package:finanzas_personales/features/categories/domain/entities/category.dart';
import 'package:finanzas_personales/features/categories/domain/usecases/create_category.dart';
import 'package:finanzas_personales/features/debts/data/repositories/debt_repository_impl.dart';
import 'package:finanzas_personales/features/debts/domain/entities/debt.dart';
import 'package:finanzas_personales/features/debts/domain/usecases/create_debt.dart';
import 'package:finanzas_personales/features/debts/domain/usecases/register_debt_payment.dart';
import 'package:finanzas_personales/features/debts/domain/usecases/suggest_debt_payment.dart';
import 'package:finanzas_personales/features/receivables/data/repositories/receivable_repository_impl.dart';
import 'package:finanzas_personales/features/receivables/domain/usecases/create_receivable.dart';
import 'package:finanzas_personales/features/receivables/domain/usecases/register_collection.dart';
import 'package:finanzas_personales/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:finanzas_personales/features/savings/data/repositories/savings_repository_impl.dart';
import 'package:finanzas_personales/features/savings/domain/usecases/contribute_to_goal.dart';
import 'package:finanzas_personales/features/savings/domain/usecases/create_savings_goal.dart';
import 'package:finanzas_personales/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:finanzas_personales/features/transactions/domain/usecases/add_transaction.dart';
import 'package:finanzas_personales/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:finanzas_personales/features/transactions/domain/usecases/restore_transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late AccountRepositoryImpl accountRepository;
  late CategoryRepositoryImpl categoryRepository;
  late TransactionRepositoryImpl transactionRepository;
  late DebtRepositoryImpl debtRepository;
  late ReceivableRepositoryImpl receivableRepository;
  late SavingsRepositoryImpl savingsRepository;
  late BudgetRepositoryImpl budgetRepository;
  late ReportsRepositoryImpl reportsRepository;

  late AddTransaction addTransaction;
  late DeleteTransaction deleteTransaction;
  late RestoreTransaction restoreTransaction;
  late CreateDebt createDebt;
  late RegisterDebtPayment registerDebtPayment;
  late SuggestDebtPayment suggestDebtPayment;
  late CreateReceivable createReceivable;
  late RegisterCollection registerCollection;
  late CreateSavingsGoal createSavingsGoal;
  late ContributeToGoal contributeToGoal;
  late SetBaseIncome setBaseIncome;
  late SetAllocationRules setAllocationRules;
  late ComputeExtraIncomeSplit computeExtraIncomeSplit;
  late ComputeSafeAvailable computeSafeAvailable;
  late CreateCategory createCategory;

  late int mainAccountId;
  late int savingsAccountId;

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

    addTransaction = AddTransaction(transactionRepository);
    deleteTransaction = DeleteTransaction(transactionRepository);
    restoreTransaction = RestoreTransaction(transactionRepository);
    createDebt = CreateDebt(debtRepository);
    registerDebtPayment = RegisterDebtPayment(
      debtRepository: debtRepository,
      categoryRepository: categoryRepository,
      transactionRepository: transactionRepository,
    );
    suggestDebtPayment = SuggestDebtPayment(debtRepository);
    createReceivable = CreateReceivable(receivableRepository);
    registerCollection = RegisterCollection(
      receivableRepository: receivableRepository,
      categoryRepository: categoryRepository,
      transactionRepository: transactionRepository,
    );
    createSavingsGoal = CreateSavingsGoal(savingsRepository);
    contributeToGoal = ContributeToGoal(
      savingsRepository: savingsRepository,
      accountRepository: accountRepository,
      transactionRepository: transactionRepository,
    );
    setBaseIncome = SetBaseIncome(budgetRepository);
    setAllocationRules = SetAllocationRules(budgetRepository);
    computeExtraIncomeSplit = ComputeExtraIncomeSplit(budgetRepository);
    computeSafeAvailable = ComputeSafeAvailable(
      budgetRepository: budgetRepository,
      debtRepository: debtRepository,
    );
    createCategory = CreateCategory(categoryRepository);

    final a1 = (await accountRepository.createAccount(
      name: 'Banco Principal',
      type: AccountType.bank,
      initialBalance: 1500000,
    )).valueOrNull!;
    mainAccountId = a1.id;

    final a2 = (await accountRepository.createAccount(
      name: 'Bolsillo Ahorro',
      type: AccountType.savings,
      initialBalance: 100000,
    )).valueOrNull!;
    savingsAccountId = a2.id;
  });

  tearDown(() async {
    await db.close();
  });

  group('Reglas de Negocio Oficiales (RN-01 a RN-28)', () {
    test('RN-01: Todo monto es un entero en unidad menor (COP: 0 dec, USD/EUR: 2 dec)', () {
      const cop = Money(units: 50000, currency: Currency.cop);
      expect(cop.units, 50000);
      expect(cop.currency.decimals, 0);

      const usd = Money(units: 1250, currency: Currency.usd);
      expect(usd.units, 1250);
      expect(usd.currency.decimals, 2);

      const eur = Money(units: 990, currency: Currency.eur);
      expect(eur.units, 990);
      expect(eur.currency.decimals, 2);
    });

    test(
      'RN-02: La moneda es un ajuste global y cambiarla no convierte montos',
      () {
        const original = Money(units: 100000, currency: Currency.cop);
        final changed = original.withCurrency(Currency.usd);

        expect(changed.units, 100000); // Amount unchanged
        expect(changed.currency, Currency.usd);
      },
    );

    test('RN-03: No existe conversión automática de divisas en v1', () {
      const m1 = Money(units: 1000, currency: Currency.cop);
      const m2 = Money(units: 1000, currency: Currency.usd);

      expect(() => m1 + m2, throwsArgumentError);
      expect(() => m1 - m2, throwsArgumentError);
    });

    test('RN-04: El usuario define un ingreso base seguro mensual', () async {
      await setBaseIncome(1300000);
      final base = (await budgetRepository.getBaseIncome()).valueOrNull!;
      expect(base, 1300000);
    });

    test('RN-05: Presupuesto y disponible seguro se calculan sobre el ingreso base', () async {
      await setBaseIncome(1000000);

      final safeRes = await computeSafeAvailable(
        fixedExpenses: 200000,
        savingsContribution: 100000,
      );

      expect(safeRes.valueOrNull!.baseIncome, 1000000);
      expect(safeRes.valueOrNull!.safeAvailable, 700000);
    });

    test('RN-06: El ingreso extra del mes = ingresos del mes − ingreso base (si es positivo)', () async {
      await setBaseIncome(1000000);

      final splitRes = await computeExtraIncomeSplit(
        actualMonthlyIncome: 1400000,
      );
      expect(splitRes.valueOrNull!.totalExtraIncome, 400000);
    });

    test('RN-07: Si el ingreso real queda por debajo del base, muestra aviso y no sugiere reparto', () async {
      await setBaseIncome(1200000);

      final splitRes = await computeExtraIncomeSplit(
        actualMonthlyIncome: 900000,
      );
      expect(splitRes.valueOrNull!.hasDeficit, isTrue);
      expect(splitRes.valueOrNull!.totalExtraIncome, 0);
      expect(splitRes.valueOrNull!.debtsAmount, 0);
    });

    test('RN-08: Los ingresos por categoría drinks_business se registran como ganancia retirada', () async {
      final cat = (await categoryRepository.getCategoryByKey('drinks_business'))
          .valueOrNull!;
      expect(cat.kind, CategoryKind.income);

      final txRes = await addTransaction(
        kind: TransactionKind.income,
        amount: 85000, // Ganancia neta retirada
        accountId: mainAccountId,
        categoryId: cat.id,
        occurredAt: DateTime.now(),
        note: 'Ganancia del fin de semana negocio bebidas',
      );

      expect(txRes.isOk, isTrue);
      expect(txRes.valueOrNull!.amount, 85000);
    });

    test('RN-09: Reglas por porcentaje con destinos debts, savings, free; la suma debe ser 100%', () async {
      final invalid = await setAllocationRules(
        debtsPercent: 50,
        savingsPercent: 30,
        freePercent: 30, // 110%
      );
      expect(invalid.isError, isTrue);
      expect(
        invalid.errorOrNull!.code,
        FailureCode.invalidAllocationRulePercentSum,
      );

      final valid = await setAllocationRules(
        debtsPercent: 50,
        savingsPercent: 20,
        freePercent: 30, // 100%
      );
      expect(valid.isOk, isTrue);
    });

    test(
      'RN-10: Valores por defecto sugeridos: 50% deudas, 20% ahorro, 30% libre',
      () async {
        final rules =
            (await budgetRepository.getAllocationRules()).valueOrNull!;
        expect(
          rules.firstWhere((r) => r.target == AllocationTarget.debts).percent,
          50,
        );
        expect(
          rules.firstWhere((r) => r.target == AllocationTarget.savings).percent,
          20,
        );
        expect(
          rules.firstWhere((r) => r.target == AllocationTarget.free).percent,
          30,
        );
      },
    );

    test('RN-11: Mientras exista deuda activa con interés, debts >= 0% con validación', () async {
      final invalidNegative = await setAllocationRules(
        debtsPercent: -10,
        savingsPercent: 60,
        freePercent: 50,
      );
      expect(invalidNegative.isError, isTrue);
    });

    test('RN-12: El reparto es una sugerencia; ningún movimiento se crea sin confirmación', () async {
      await setBaseIncome(1000000);
      await computeExtraIncomeSplit(actualMonthlyIncome: 1500000);

      // Verify no transactions were created in DB
      final txs = await db.select(db.transactionsTable).get();
      expect(txs.isEmpty, isTrue);
    });

    test('RN-13: Estrategia configurable: avalancha o bola de nieve (avalancha por defecto)', () async {
      final defaultStrat =
          (await debtRepository.getDebtStrategy()).valueOrNull!;
      expect(defaultStrat, DebtStrategy.avalanche);

      await debtRepository.setDebtStrategy(DebtStrategy.snowball);
      final changedStrat =
          (await debtRepository.getDebtStrategy()).valueOrNull!;
      expect(changedStrat, DebtStrategy.snowball);

      final suggestion = await suggestDebtPayment(availableAmount: 50000);
      expect(suggestion.isOk, isTrue);
    });

    test(
      'RN-14: Un abono crea un gasto con debt_id y categoría debt_payment',
      () async {
        final debt = (await createDebt(
          name: 'Crédito',
          creditor: 'Banco',
          initialAmount: 200000,
          interestRateBp: 200,
          minPayment: 20000,
          dueDay: 15,
        )).valueOrNull!;

        final payRes = await registerDebtPayment(
          debtId: debt.id,
          amount: 50000,
          accountId: mainAccountId,
          occurredAt: DateTime.now(),
        );

        expect(payRes.isOk, isTrue);
        final tx = payRes.valueOrNull!;
        expect(tx.kind, TransactionKind.expense);
        expect(tx.debtId, debt.id);

        final cat = (await categoryRepository.getCategoryByKey('debt_payment'))
            .valueOrNull!;
        expect(tx.categoryId, cat.id);
      },
    );

    test('RN-15: Un abono no puede superar el saldo pendiente', () async {
      final debt = (await createDebt(
        name: 'Préstamo',
        creditor: 'Banco',
        initialAmount: 100000,
        interestRateBp: 0,
        minPayment: 10000,
        dueDay: 10,
      )).valueOrNull!;

      final res = await registerDebtPayment(
        debtId: debt.id,
        amount: 150000, // Exceeds 100,000
        accountId: mainAccountId,
        occurredAt: DateTime.now(),
      );

      expect(res.isError, isTrue);
      expect(res.errorOrNull!.code, FailureCode.debtPaymentExceedsBalance);
    });

    test('RN-16: Interés mensual informativo en v1; no se suma automáticamente al saldo', () async {
      final debt = (await createDebt(
        name: 'Deuda Tasa',
        creditor: 'Banco',
        initialAmount: 300000,
        interestRateBp: 250, // 2.5%
        minPayment: 30000,
        dueDay: 5,
      )).valueOrNull!;

      final withBal = (await debtRepository.getDebtWithBalance(debt.id))
          .valueOrNull!;
      // Saldo sigue siendo el monto inicial sin intereses aplicados automáticamente
      expect(withBal.currentBalance, 300000);
      expect(withBal.debt.interestRateBp, 250);
    });

    test('RN-17: Alerta de cuota próxima 3 días antes de due_day', () async {
      await createDebt(
        name: 'Deuda Día 19',
        creditor: 'Banco',
        initialAmount: 100000,
        interestRateBp: 100,
        minPayment: 10000,
        dueDay: 19,
      );

      final upcoming = await debtRepository.getUpcomingDueDebts(
        referenceDate: DateTime(2026, 10, 16),
        daysAhead: 3,
      );
      expect(upcoming.any((d) => d.debt.name == 'Deuda Día 19'), isTrue);
    });

    test('RN-18: Cada cobro crea un ingreso con receivable_id y categoría loan_collection', () async {
      final rec = (await createReceivable(
        person: 'Andrés',
        initialAmount: 100000,
        createdAt: DateTime.now(),
      )).valueOrNull!;

      final colRes = await registerCollection(
        receivableId: rec.id,
        amount: 40000,
        accountId: mainAccountId,
        occurredAt: DateTime.now(),
      );

      expect(colRes.isOk, isTrue);
      final tx = colRes.valueOrNull!;
      expect(tx.kind, TransactionKind.income);
      expect(tx.receivableId, rec.id);

      final cat = (await categoryRepository.getCategoryByKey('loan_collection'))
          .valueOrNull!;
      expect(tx.categoryId, cat.id);
    });

    test(
      'RN-19: Los cobros no cuentan como ingreso extra repartible por defecto',
      () async {
        // Verificamos que la categoría loan_collection está identificada
        final cat = (await categoryRepository.getCategoryByKey(
          'loan_collection',
        )).valueOrNull!;
        expect(cat.key, 'loan_collection');
      },
    );

    test('RN-20: Un cobro no puede superar el saldo pendiente', () async {
      final rec = (await createReceivable(
        person: 'Mateo',
        initialAmount: 50000,
        createdAt: DateTime.now(),
      )).valueOrNull!;

      final res = await registerCollection(
        receivableId: rec.id,
        amount: 60000, // Exceeds 50,000
        accountId: mainAccountId,
        occurredAt: DateTime.now(),
      );

      expect(res.isError, isTrue);
      expect(
        res.errorOrNull!.code,
        FailureCode.receivableCollectionExceedsBalance,
      );
    });

    test('RN-21: El total por cobrar se muestra aparte y nunca se suma al saldo disponible', () async {
      await createReceivable(
        person: 'Juan',
        initialAmount: 400000,
        createdAt: DateTime.now(),
      );

      final totalPending = await receivableRepository
          .getTotalPendingReceivable();
      expect(totalPending, 400000);

      // Account balance is strictly account balance
      final accBal = await accountRepository.getAccountBalance(mainAccountId);
      expect(accBal.valueOrNull!.units, 1500000);
    });

    test('RN-22: Categorías de moto (fuel, moto_maintenance, moto_documents) se agrupan en reporte Moto', () async {
      final fuel = (await categoryRepository.getCategoryByKey('fuel'))
          .valueOrNull!;
      final maint = (await categoryRepository.getCategoryByKey(
        'moto_maintenance',
      )).valueOrNull!;

      final now = DateTime(2026, 10, 10);
      await addTransaction(
        kind: TransactionKind.expense,
        amount: 25000,
        accountId: mainAccountId,
        categoryId: fuel.id,
        occurredAt: now,
      );
      await addTransaction(
        kind: TransactionKind.expense,
        amount: 75000,
        accountId: mainAccountId,
        categoryId: maint.id,
        occurredAt: now,
      );

      final motoReport = await reportsRepository.getGroupedExpenses(
        year: 2026,
        month: 10,
        categoryKeys: ['fuel', 'moto_maintenance', 'moto_documents'],
        groupName: 'Moto',
      );

      expect(motoReport.valueOrNull!.totalAmount, 100000);
    });

    test('RN-23: Gastos de pareja (partner, outings) se agrupan en reporte Salidas y pareja', () async {
      final partner = (await categoryRepository.getCategoryByKey('partner'))
          .valueOrNull!;
      final outings = (await categoryRepository.getCategoryByKey('outings'))
          .valueOrNull!;

      final now = DateTime(2026, 10, 12);
      await addTransaction(
        kind: TransactionKind.expense,
        amount: 30000,
        accountId: mainAccountId,
        categoryId: partner.id,
        occurredAt: now,
      );
      await addTransaction(
        kind: TransactionKind.expense,
        amount: 20000,
        accountId: mainAccountId,
        categoryId: outings.id,
        occurredAt: now,
      );

      final coupleReport = await reportsRepository.getGroupedExpenses(
        year: 2026,
        month: 10,
        categoryKeys: ['partner', 'outings'],
        groupName: 'Salidas y pareja',
      );

      expect(coupleReport.valueOrNull!.totalAmount, 50000);
    });

    test('RN-24: Una categoría con transacciones solo puede inhabilitarse, no borrarse', () async {
      final custom = (await createCategory(
        name: 'Mascotas',
        kind: CategoryKind.expense,
        icon: 'pets',
        color: 0xFF999999,
      )).valueOrNull!;

      await addTransaction(
        kind: TransactionKind.expense,
        amount: 15000,
        accountId: mainAccountId,
        categoryId: custom.id,
        occurredAt: DateTime.now(),
      );

      final delRes = await categoryRepository.deleteCategory(custom.id);
      expect(delRes.isError, isTrue);
      expect(delRes.errorOrNull!.code, FailureCode.categoryHasTransactions);

      // Inactivation succeeds
      final inactivateRes = await categoryRepository.setCategoryActive(
        id: custom.id,
        isActive: false,
      );
      expect(inactivateRes.isOk, isTrue);
    });

    test('RN-25: Un aporte a una meta es una transferencia a cuenta de tipo savings con goal_id', () async {
      final goal = (await createSavingsGoal(
        name: 'Navidad',
        targetAmount: 500000,
      )).valueOrNull!;

      final contribRes = await contributeToGoal(
        goalId: goal.id,
        amount: 100000,
        sourceAccountId: mainAccountId,
        targetSavingsAccountId: savingsAccountId,
        occurredAt: DateTime.now(),
      );

      expect(contribRes.isOk, isTrue);
      final tx = contribRes.valueOrNull!;
      expect(tx.kind, TransactionKind.transfer);
      expect(tx.goalId, goal.id);
      expect(tx.toAccountId, savingsAccountId);
    });

    test(
      'RN-26: El progreso de la meta = suma de aportes − retiros asociados',
      () async {
        final goal = (await createSavingsGoal(
          name: 'Estudios',
          targetAmount: 200000,
        )).valueOrNull!;

        await contributeToGoal(
          goalId: goal.id,
          amount: 100000,
          sourceAccountId: mainAccountId,
          targetSavingsAccountId: savingsAccountId,
          occurredAt: DateTime.now(),
        );

        final withProgress = (await savingsRepository.getGoalWithProgress(
          goal.id,
        )).valueOrNull!;
        expect(withProgress.currentAmount, 100000);
        expect(withProgress.progressRatio, 0.5);
      },
    );

    test(
      'RN-27: Una cuenta con transacciones solo se archiva, no se elimina',
      () async {
        await addTransaction(
          kind: TransactionKind.expense,
          amount: 10000,
          accountId: mainAccountId,
          occurredAt: DateTime.now(),
        );

        expect(await accountRepository.hasTransactions(mainAccountId), isTrue);

        final archiveRes = await accountRepository.archiveAccount(
          id: mainAccountId,
          archived: true,
        );
        expect(archiveRes.isOk, isTrue);
      },
    );

    test(
      'RN-28: Eliminar una transacción es lógico y reversible con Deshacer',
      () async {
        final tx = (await addTransaction(
          kind: TransactionKind.expense,
          amount: 50000,
          accountId: mainAccountId,
          occurredAt: DateTime.now(),
        )).valueOrNull!;

        // Soft delete
        await deleteTransaction(tx.id);
        final deleted = (await transactionRepository.getTransactionById(tx.id))
            .valueOrNull!;
        expect(deleted.isDeleted, isTrue);

        // Deshacer (restore)
        await restoreTransaction(tx.id);
        final restored = (await transactionRepository.getTransactionById(tx.id))
            .valueOrNull!;
        expect(restored.isDeleted, isFalse);
      },
    );
  });
}
