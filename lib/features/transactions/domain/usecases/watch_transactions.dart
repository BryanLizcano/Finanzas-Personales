import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class WatchTransactions {
  final TransactionRepository _repository;

  const WatchTransactions(this._repository);

  Stream<List<TransactionEntity>> call([TransactionFilter? filter]) {
    return _repository.watchTransactions(filter);
  }
}
