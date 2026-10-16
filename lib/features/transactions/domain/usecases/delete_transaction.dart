import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository _repository;

  const DeleteTransaction(this._repository);

  Future<Result<void, Failure>> call(int id) async {
    return _repository.deleteTransaction(id);
  }
}
