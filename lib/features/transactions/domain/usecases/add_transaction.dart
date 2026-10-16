import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository _repository;

  const AddTransaction(this._repository);

  Future<Result<TransactionEntity, Failure>> call({
    required TransactionKind kind,
    required int amount,
    required int accountId,
    int? toAccountId,
    int? categoryId,
    int? debtId,
    int? receivableId,
    int? goalId,
    required DateTime occurredAt,
    String note = '',
  }) async {
    // 1. amount > 0
    if (amount <= 0) {
      return const Result.error(
        Failure(FailureCode.invalidAmount, 'Amount must be greater than 0'),
      );
    }

    // 2. transfer integrity
    if (kind == TransactionKind.transfer) {
      if (toAccountId == null || toAccountId == accountId) {
        return const Result.error(
          Failure(
            FailureCode.invalidTransferSameAccount,
            'Transfer destination must differ from origin',
          ),
        );
      }
      if (categoryId != null) {
        return const Result.error(
          Failure(
            FailureCode.invalidTransferSameAccount,
            'Transfer cannot have a category',
          ),
        );
      }
    }

    // 3. debt_id only in expense
    if (debtId != null && kind != TransactionKind.expense) {
      return const Result.error(
        Failure(
          FailureCode.invalidAmount,
          'debt_id can only be specified on expenses',
        ),
      );
    }

    // 4. receivable_id only in income
    if (receivableId != null && kind != TransactionKind.income) {
      return const Result.error(
        Failure(
          FailureCode.invalidAmount,
          'receivable_id can only be specified on incomes',
        ),
      );
    }

    return _repository.addTransaction(
      kind: kind,
      amount: amount,
      accountId: accountId,
      toAccountId: toAccountId,
      categoryId: categoryId,
      debtId: debtId,
      receivableId: receivableId,
      goalId: goalId,
      occurredAt: occurredAt,
      note: note.trim(),
    );
  }
}
