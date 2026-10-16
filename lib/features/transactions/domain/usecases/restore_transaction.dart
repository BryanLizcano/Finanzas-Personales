import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class RestoreTransaction {
  final TransactionRepository _repository;

  const RestoreTransaction(this._repository);

  Future<Result<TransactionEntity, Failure>> call(int id) async {
    return _repository.restoreTransaction(id);
  }
}
