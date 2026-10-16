import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/categories/data/repositories/category_repository_impl.dart';
import 'package:finanzas_personales/features/debts/data/repositories/debt_repository_impl.dart';
import 'package:finanzas_personales/features/debts/domain/entities/debt.dart';
import 'package:finanzas_personales/features/debts/domain/usecases/create_debt.dart';
import 'package:finanzas_personales/features/debts/domain/usecases/register_debt_payment.dart';
import 'package:finanzas_personales/features/debts/domain/usecases/suggest_debt_payment.dart';
import 'package:finanzas_personales/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late DebtRepositoryImpl debtRepository;
  late CategoryRepositoryImpl categoryRepository;
  late TransactionRepositoryImpl transactionRepository;
  late AccountRepositoryImpl accountRepository;

  late CreateDebt createDebt;
  late RegisterDebtPayment registerDebtPayment;
  late SuggestDebtPayment suggestDebtPayment;

  late int accountId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    debtRepository = DebtRepositoryImpl(db);
    categoryRepository = CategoryRepositoryImpl(db);
    transactionRepository = TransactionRepositoryImpl(db);
    accountRepository = AccountRepositoryImpl(db);

    createDebt = CreateDebt(debtRepository);
    registerDebtPayment = RegisterDebtPayment(
      debtRepository: debtRepository,
      categoryRepository: categoryRepository,
      transactionRepository: transactionRepository,
    );
    suggestDebtPayment = SuggestDebtPayment(debtRepository);

    final acc = (await accountRepository.createAccount(
      name: 'Nequi',
      type: AccountType.bank,
      initialBalance: 1000000,
    )).valueOrNull!;
    accountId = acc.id;
  });

  tearDown(() async {
    await db.close();
  });

  group(
    'Debts (T-030, T-031, T-033, T-034, RN-13, RN-14, RN-15, RN-16, RN-17)',
    () {
      test('creates debt with initial amount and calculates balance', () async {
        final res = await createDebt(
          name: 'Tarjeta de Crédito',
          creditor: 'Bancolombia',
          initialAmount: 500000,
          interestRateBp: 250, // 2.5% monthly
          minPayment: 50000,
          dueDay: 15,
        );

        expect(res.isOk, isTrue);
        final debt = res.valueOrNull!;
        expect(debt.name, 'Tarjeta de Crédito');
        expect(debt.initialAmount, 500000);

        final withBalance = (await debtRepository.getDebtWithBalance(debt.id))
            .valueOrNull!;
        expect(withBalance.currentBalance, 500000);
        expect(withBalance.paidAmount, 0);
        expect(withBalance.isPaidOff, isFalse);
      });

      test('RN-14 & RN-15: payment creates expense linked to debt and cannot exceed balance', () async {
        final debt = (await createDebt(
          name: 'Préstamo Amigo',
          creditor: 'Carlos',
          initialAmount: 100000,
          interestRateBp: 0,
          minPayment: 20000,
          dueDay: 20,
        )).valueOrNull!;

        // RN-15: Attempt to pay more than balance
        final excessPayment = await registerDebtPayment(
          debtId: debt.id,
          amount: 120000,
          accountId: accountId,
          occurredAt: DateTime.now(),
        );
        expect(excessPayment.isError, isTrue);
        expect(
          excessPayment.errorOrNull!.code,
          FailureCode.debtPaymentExceedsBalance,
        );

        // RN-14: Valid payment
        final validPayment = await registerDebtPayment(
          debtId: debt.id,
          amount: 60000,
          accountId: accountId,
          occurredAt: DateTime.now(),
        );
        expect(validPayment.isOk, isTrue);
        final tx = validPayment.valueOrNull!;
        expect(tx.kind, TransactionKind.expense);
        expect(tx.debtId, debt.id);

        final debtCat = (await categoryRepository.getCategoryByKey(
          'debt_payment',
        )).valueOrNull!;
        expect(tx.categoryId, debtCat.id);

        // Verify new debt balance: 100000 - 60000 = 40000
        final updatedDebt = (await debtRepository.getDebtWithBalance(debt.id))
            .valueOrNull!;
        expect(updatedDebt.paidAmount, 60000);
        expect(updatedDebt.currentBalance, 40000);
        expect(updatedDebt.isPaidOff, isFalse);

        // Complete payment
        final finalPayment = await registerDebtPayment(
          debtId: debt.id,
          amount: 40000,
          accountId: accountId,
          occurredAt: DateTime.now(),
        );
        expect(finalPayment.isOk, isTrue);

        final settledDebt = (await debtRepository.getDebtWithBalance(debt.id))
            .valueOrNull!;
        expect(settledDebt.currentBalance, 0);
        expect(settledDebt.isPaidOff, isTrue);
      });

      test(
        'RN-13: suggests payment by avalanche vs snowball strategy',
        () async {
          // Debt 1: Large balance, low interest
          await createDebt(
            name: 'Préstamo Auto',
            creditor: 'Banco',
            initialAmount: 800000,
            interestRateBp: 150, // 1.5%
            minPayment: 50000,
            dueDay: 10,
          );

          // Debt 2: Small balance, high interest
          final d2 = (await createDebt(
            name: 'Tarjeta Oro',
            creditor: 'Banco',
            initialAmount: 200000,
            interestRateBp: 300, // 3.0%
            minPayment: 30000,
            dueDay: 15,
          )).valueOrNull!;

          // Avalanche (default): highest interest rate first -> d2 (300 bp)
          final avalancheRes = await suggestDebtPayment(
            strategyOverride: DebtStrategy.avalanche,
          );
          expect(avalancheRes.isOk, isTrue);
          expect(avalancheRes.valueOrNull!.targetDebt!.debt.id, d2.id);

          // Snowball: lowest balance first -> d2 (200000 < 800000)
          final snowballRes = await suggestDebtPayment(
            strategyOverride: DebtStrategy.snowball,
          );
          expect(snowballRes.isOk, isTrue);
          expect(snowballRes.valueOrNull!.targetDebt!.debt.id, d2.id);

          // Now create Debt 3: Tiny balance (50000), lowest interest (100 bp)
          final d3 = (await createDebt(
            name: 'Celular',
            creditor: 'Claro',
            initialAmount: 50000,
            interestRateBp: 100, // 1.0%
            minPayment: 10000,
            dueDay: 5,
          )).valueOrNull!;

          // In Avalanche: d2 is still first because 300 bp > 150 bp > 100 bp
          final avalancheWithD3 = await suggestDebtPayment(
            strategyOverride: DebtStrategy.avalanche,
          );
          expect(avalancheWithD3.valueOrNull!.targetDebt!.debt.id, d2.id);

          // In Snowball: d3 is now first because 50000 < 200000 < 800000
          final snowballWithD3 = await suggestDebtPayment(
            strategyOverride: DebtStrategy.snowball,
          );
          expect(snowballWithD3.valueOrNull!.targetDebt!.debt.id, d3.id);
        },
      );

      test(
        'RN-16: interest rate is informative and does not auto-alter balance',
        () async {
          final debt = (await createDebt(
            name: 'Deuda Informativa',
            creditor: 'Banco',
            initialAmount: 100000,
            interestRateBp: 200, // 2%
            minPayment: 10000,
            dueDay: 10,
          )).valueOrNull!;

          // Current balance stays equal to initial minus payments, interest rate is simply stored
          final withBalance = (await debtRepository.getDebtWithBalance(debt.id))
              .valueOrNull!;
          expect(withBalance.currentBalance, 100000);
          expect(withBalance.debt.interestRateBp, 200);
        },
      );

      test('RN-17: upcoming due date detection 3 days ahead', () async {
        await createDebt(
          name: 'Deuda Próxima',
          creditor: 'Banco A',
          initialAmount: 100000,
          interestRateBp: 100,
          minPayment: 10000,
          dueDay: 18,
        );
        await createDebt(
          name: 'Deuda Lejana',
          creditor: 'Banco B',
          initialAmount: 100000,
          interestRateBp: 100,
          minPayment: 10000,
          dueDay: 28,
        );

        final referenceDate = DateTime(2026, 10, 16);
        final upcoming = await debtRepository.getUpcomingDueDebts(
          referenceDate: referenceDate,
          daysAhead: 3,
        );

        expect(upcoming.length, 1);
        expect(upcoming.first.debt.name, 'Deuda Próxima');
      });
    },
  );
}
