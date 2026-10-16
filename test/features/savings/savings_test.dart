import 'package:drift/native.dart';
import 'package:finanzas_personales/core/database/app_database.dart';
import 'package:finanzas_personales/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finanzas_personales/features/accounts/domain/entities/account.dart';
import 'package:finanzas_personales/features/savings/data/repositories/savings_repository_impl.dart';
import 'package:finanzas_personales/features/savings/domain/usecases/contribute_to_goal.dart';
import 'package:finanzas_personales/features/savings/domain/usecases/create_savings_goal.dart';
import 'package:finanzas_personales/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finanzas_personales/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late SavingsRepositoryImpl savingsRepository;
  late AccountRepositoryImpl accountRepository;
  late TransactionRepositoryImpl transactionRepository;

  late CreateSavingsGoal createSavingsGoal;
  late ContributeToGoal contributeToGoal;

  late int cashAccountId;
  late int savingsAccountId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    savingsRepository = SavingsRepositoryImpl(db);
    accountRepository = AccountRepositoryImpl(db);
    transactionRepository = TransactionRepositoryImpl(db);

    createSavingsGoal = CreateSavingsGoal(savingsRepository);
    contributeToGoal = ContributeToGoal(
      savingsRepository: savingsRepository,
      accountRepository: accountRepository,
      transactionRepository: transactionRepository,
    );

    final cash = (await accountRepository.createAccount(
      name: 'Efectivo',
      type: AccountType.cash,
      initialBalance: 200000,
    )).valueOrNull!;
    cashAccountId = cash.id;

    final savings = (await accountRepository.createAccount(
      name: 'Fondo Emergencia',
      type: AccountType.savings,
      initialBalance: 0,
    )).valueOrNull!;
    savingsAccountId = savings.id;
  });

  tearDown(() async {
    await db.close();
  });

  group('Savings Goals & Contributions (T-050, RN-25, RN-26)', () {
    test('creates savings goal with target amount', () async {
      final res = await createSavingsGoal(
        name: 'Viaje a la Costa',
        targetAmount: 500000,
        targetDate: DateTime(2026, 12, 31),
      );

      expect(res.isOk, isTrue);
      final goal = res.valueOrNull!;
      expect(goal.name, 'Viaje a la Costa');
      expect(goal.targetAmount, 500000);

      final withProgress = (await savingsRepository.getGoalWithProgress(
        goal.id,
      )).valueOrNull!;
      expect(withProgress.currentAmount, 0);
      expect(withProgress.progressRatio, 0.0);
      expect(withProgress.isCompleted, isFalse);
    });

    test('RN-25 & RN-26: contribution creates transfer to savings account and updates progress', () async {
      final goal = (await createSavingsGoal(
        name: 'Casco Moto',
        targetAmount: 150000,
      )).valueOrNull!;

      // Transfer to non-savings account should fail
      final otherCash = (await accountRepository.createAccount(
        name: 'Caja Chica',
        type: AccountType.cash,
        initialBalance: 10000,
      )).valueOrNull!;

      final invalidDest = await contributeToGoal(
        goalId: goal.id,
        amount: 50000,
        sourceAccountId: cashAccountId,
        targetSavingsAccountId: otherCash.id,
        occurredAt: DateTime.now(),
      );
      expect(invalidDest.isError, isTrue);

      // RN-25: Valid contribution transfer to savings account
      final contribRes = await contributeToGoal(
        goalId: goal.id,
        amount: 75000,
        sourceAccountId: cashAccountId,
        targetSavingsAccountId: savingsAccountId,
        occurredAt: DateTime.now(),
      );

      expect(contribRes.isOk, isTrue);
      final tx = contribRes.valueOrNull!;
      expect(tx.kind, TransactionKind.transfer);
      expect(tx.goalId, goal.id);

      // Verify accounts balances: cash decreased, savings increased
      final cashBal = await accountRepository.getAccountBalance(cashAccountId);
      final savingsBal = await accountRepository.getAccountBalance(
        savingsAccountId,
      );
      expect(cashBal.valueOrNull!.units, 125000);
      expect(savingsBal.valueOrNull!.units, 75000);

      // RN-26: Goal progress updated (75000 / 150000 = 50%)
      final progress1 = (await savingsRepository.getGoalWithProgress(goal.id))
          .valueOrNull!;
      expect(progress1.currentAmount, 75000);
      expect(progress1.progressRatio, 0.5);
      expect(progress1.isCompleted, isFalse);

      // Second contribution to complete goal
      await contributeToGoal(
        goalId: goal.id,
        amount: 75000,
        sourceAccountId: cashAccountId,
        targetSavingsAccountId: savingsAccountId,
        occurredAt: DateTime.now(),
      );

      final progress2 = (await savingsRepository.getGoalWithProgress(goal.id))
          .valueOrNull!;
      expect(progress2.currentAmount, 150000);
      expect(progress2.progressRatio, 1.0);
      expect(progress2.isCompleted, isTrue);
    });
  });
}
