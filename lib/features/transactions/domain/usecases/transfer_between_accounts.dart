import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class TransferBetweenAccounts {
  final TransactionRepository _repository;

  const TransferBetweenAccounts(this._repository);

  Future<Result<TransactionEntity, Failure>> call({
    required int sourceAccountId,
    required int targetAccountId,
    required int amount,
    required DateTime occurredAt,
    int? goalId,
    String note = '',
  }) async {
    if (amount <= 0) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Amount must be greater than 0'),
      );
    }

    if (sourceAccountId == targetAccountId) {
      return const Result.error(
        Failure(
          FailureCode.invalidTransferSameAccount,
          'Cannot transfer to the same account',
        ),
      );
    }

    return _repository.addTransaction(
      kind: TransactionKind.transfer,
      amount: amount,
      accountId: sourceAccountId,
      toAccountId: targetAccountId,
      occurredAt: occurredAt,
      goalId: goalId,
      note: note.trim(),
    );
  }
}
