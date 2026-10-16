import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Result<TransactionEntity, Failure>> addTransaction({
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
  });

  Future<Result<TransactionEntity, Failure>> updateTransaction({
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
  });

  Future<Result<void, Failure>> deleteTransaction(int id);

  Future<Result<TransactionEntity, Failure>> restoreTransaction(int id);

  Future<Result<TransactionEntity?, Failure>> getTransactionById(int id);

  Stream<List<TransactionEntity>> watchTransactions([
    TransactionFilter? filter,
  ]);

  Future<List<TransactionEntity>> getTransactions([TransactionFilter? filter]);
}
