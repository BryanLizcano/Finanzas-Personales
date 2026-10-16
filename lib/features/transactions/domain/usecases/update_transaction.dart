import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository _repository;

  const UpdateTransaction(this._repository);

  Future<Result<TransactionEntity, Failure>> call({
    required int id,
    int? amount,
    int? accountId,
    int? toAccountId,
    int? categoryId,
    int? debtId,
    int? receivableId,
    int? goalId,
    DateTime? occurredAt,
    String? note,
  }) async {
    if (amount != null && amount <= 0) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Amount must be greater than 0'),
      );
    }

    if (accountId != null && toAccountId != null && accountId == toAccountId) {
      return const Result.error(
        Failure(
          FailureCode.invalidTransferSameAccount,
          'Transfer destination must differ from origin',
        ),
      );
    }

    return _repository.updateTransaction(
      id: id,
      amount: amount,
      accountId: accountId,
      toAccountId: toAccountId,
      categoryId: categoryId,
      debtId: debtId,
      receivableId: receivableId,
      goalId: goalId,
      occurredAt: occurredAt,
      note: note?.trim(),
    );
  }
}
