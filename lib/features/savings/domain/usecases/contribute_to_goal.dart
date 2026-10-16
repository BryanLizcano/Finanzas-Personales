import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../repositories/savings_repository.dart';

class ContributeToGoal {
  final SavingsRepository savingsRepository;
  final AccountRepository accountRepository;
  final TransactionRepository transactionRepository;

  const ContributeToGoal({
    required this.savingsRepository,
    required this.accountRepository,
    required this.transactionRepository,
  });

  Future<Result<TransactionEntity, Failure>> call({
    required int goalId,
    required int amount,
    required int sourceAccountId,
    required int targetSavingsAccountId,
    required DateTime occurredAt,
    String note = '',
  }) async {
    // 1. Validate amount
    if (amount <= 0) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Contribution amount must be > 0'),
      );
    }

    // 2. Validate transfer accounts
    if (sourceAccountId == targetSavingsAccountId) {
      return const Result.error(
        Failure(
          FailureCode.invalidTransferSameAccount,
          'Savings account destination must differ from origin account',
        ),
      );
    }

    // 3. Verify goal exists
    final goalRes = await savingsRepository.getGoalById(goalId);
    if (goalRes.isError || goalRes.valueOrNull == null) {
      return const Result.error(Failure(FailureCode.savingsGoalNotFound));
    }
    final goal = goalRes.valueOrNull!;

    // 4. Verify target account exists and is savings type (RN-25)
    final targetAccountRes = await accountRepository.getAccountById(
      targetSavingsAccountId,
    );
    if (targetAccountRes.isError || targetAccountRes.valueOrNull == null) {
      return const Result.error(Failure(FailureCode.accountNotFound));
    }
    final targetAccount = targetAccountRes.valueOrNull!;
    if (targetAccount.type != AccountType.savings) {
      return const Result.error(
        Failure(
          FailureCode.accountNotFound,
          'Target account must be of type savings',
        ),
      );
    }

    // 5. RN-25: Create transfer transaction with goal_id
    return transactionRepository.addTransaction(
      kind: TransactionKind.transfer,
      amount: amount,
      accountId: sourceAccountId,
      toAccountId: targetSavingsAccountId,
      goalId: goalId,
      occurredAt: occurredAt,
      note: note.isEmpty ? 'Aporte a meta: ${goal.name}' : note,
    );
  }
}
